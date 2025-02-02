/*
 * Copyright 2021 Jonathan Lindegaard Starup
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package ca.uwaterloo.flix.language.phase.jvm

import ca.uwaterloo.flix.api.Flix
import ca.uwaterloo.flix.language.phase.jvm.BytecodeInstructions._
import ca.uwaterloo.flix.language.phase.jvm.ClassMaker.Final._
import ca.uwaterloo.flix.language.phase.jvm.ClassMaker.InstanceField
import ca.uwaterloo.flix.language.phase.jvm.ClassMaker.Visibility._
import ca.uwaterloo.flix.language.phase.jvm.JvmName.MethodDescriptor.mkDescriptor

object GenMatchErrorClass {

  private val locationField: InstanceField =
    InstanceField(JvmName.MatchError, "location", JvmName.ReifiedSourceLocation.toTpe)

  /**
    * Creates a subclass of `dev.flix.runtime.FlixError` with a
    * `dev.flix.runtime.ReifiedSourceLocation` and a string prefix of the message.
    * Includes equals and hashCode methods.
    */
  def gen()(implicit flix: Flix): Map[JvmName, JvmClass] = {
    Map(JvmName.MatchError -> JvmClass(JvmName.MatchError, genByteCode()))
  }

  private def genByteCode()(implicit flix: Flix): Array[Byte] = {
    val cm = ClassMaker.mkClass(JvmName.MatchError, IsFinal, superClass = JvmName.FlixError)

    cm.mkConstructor(genConstructor(), mkDescriptor(JvmName.ReifiedSourceLocation.toTpe)(VoidableType.Void), IsPublic)

    locationField.mkField(cm, IsPublic, IsFinal)

    // TODO: Are these ever used?
    cm.mkMethod(genEqualsMethod(), "equals", mkDescriptor(JvmName.Object.toTpe)(BackendType.Bool), IsPublic, NotFinal)
    cm.mkMethod(genHashCodeMethod(), "hashCode", mkDescriptor()(BackendType.Int32), IsPublic, NotFinal)

    cm.closeClassMaker()
  }

  private def genConstructor(): InstructionSet = {
    val stringBuilderDescriptor = mkDescriptor(BackendObjType.String.toTpe)(JvmName.StringBuilder.toTpe)
    thisLoad() ~
      NEW(JvmName.StringBuilder) ~
      DUP() ~
      invokeConstructor(JvmName.StringBuilder) ~
      pushString("Non-exhaustive match at ") ~
      INVOKEVIRTUAL(JvmName.StringBuilder, "append", stringBuilderDescriptor) ~
      ALOAD(1) ~
      INVOKEVIRTUAL(JvmName.ReifiedSourceLocation, "toString", mkDescriptor()(BackendObjType.String.toTpe)) ~
      INVOKEVIRTUAL(JvmName.StringBuilder, "append", stringBuilderDescriptor) ~
      INVOKEVIRTUAL(JvmName.StringBuilder, "toString", mkDescriptor()(BackendObjType.String.toTpe)) ~
      invokeConstructor(JvmName.FlixError, mkDescriptor(BackendObjType.String.toTpe)(VoidableType.Void)) ~
      thisLoad() ~
      ALOAD(1) ~
      locationField.putField() ~
      RETURN()
  }

  private def genEqualsMethod(): InstructionSet = withName(1, JvmName.Object.toTpe) { otherObj =>
    // check exact equality
    thisLoad() ~
      otherObj.load() ~
      ifTrue(Condition.ACMPEQ)(pushBool(true) ~ IRETURN()) ~
      // check `other == null`
      otherObj.load() ~
      ifTrue(Condition.NULL)(pushBool(false) ~ IRETURN()) ~
      // the class equality
      thisLoad() ~
      INVOKEVIRTUAL(JvmName.Object, "getClass", mkDescriptor()(JvmName.Class.toTpe)) ~
      otherObj.load() ~
      INVOKEVIRTUAL(JvmName.Object, "getClass", mkDescriptor()(JvmName.Class.toTpe)) ~
      ifTrue(Condition.ACMPNE)(pushBool(false) ~ IRETURN()) ~
      // check individual fields
      ALOAD(1) ~ CHECKCAST(JvmName.MatchError) ~
      storeWithName(2, JvmName.MatchError.toTpe) { otherErr =>
        thisLoad() ~ locationField.getField() ~
          otherErr.load() ~ locationField.getField() ~
          INVOKESTATIC(JvmName.Objects, "equals", mkDescriptor(JvmName.Object.toTpe, JvmName.Object.toTpe)(BackendType.Bool)) ~
          IRETURN()
      }
  }

  private def genHashCodeMethod(): InstructionSet =
    ICONST_1() ~ ANEWARRAY(JvmName.Object) ~
      DUP() ~
      ICONST_0() ~
      thisLoad() ~ locationField.getField() ~
      AASTORE() ~
      INVOKESTATIC(JvmName.Object, "hash", mkDescriptor(BackendType.Array(JvmName.Object.toTpe))(BackendType.Int32)) ~
      IRETURN()
}
