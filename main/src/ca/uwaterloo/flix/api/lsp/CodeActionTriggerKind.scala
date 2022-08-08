/*
 * Copyright 2022 Nicola Dardanis
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
package ca.uwaterloo.flix.api.lsp

import org.json4s.JsonAST.JInt

sealed trait CodeActionTriggerKind {
  def toJson() = this match {
    case CodeActionTriggerKind.Invoked => JInt(1)
    case CodeActionTriggerKind.Automatic => JInt(2)
  }
}

object CodeActionTriggerKind {
  /**
    * Code actions were explicitly requested by the user or by an extension.
    */
  case object Invoked extends CodeActionTriggerKind

  /**
    * Code actions were requested automatically.
    *
    * This typically happens when current selection in a file changes, but can
    * also be triggered when file content changes.
    */
  case object Automatic extends CodeActionTriggerKind
}
