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

import org.json4s.JsonAST.JString

sealed trait CodeActionKind {
  def toJson() = {
    val s = this match {
      case CodeActionKind.Empty => ""
      case CodeActionKind.QuickFix => "quickfix"
      case CodeActionKind.Refactor => "refactor"
      case CodeActionKind.RefactorExtract => "refactor.extract"
      case CodeActionKind.RefactorInline => "refactor.inline"
      case CodeActionKind.RefactorRewrite => "refactor.rewrite"
      case CodeActionKind.Source => "source"
      case CodeActionKind.SourceOrganizeImports => "source.organizeImports"
      case CodeActionKind.SourceFixAll => "source.fixAll"
    }
    JString(s)
  }
}

object CodeActionKind {

  /**
    * Empty kind.
    */
  case object Empty extends CodeActionKind

  /**
    * Base kind for quickfix actions: 'quickfix'.
    */
  case object QuickFix extends CodeActionKind

  /**
    * Base kind for refactoring actions: 'refactor'.
    */
  case object Refactor extends CodeActionKind

  /**
    * Base kind for refactoring extraction actions: 'refactor.extract'.
    *
    * Example extract actions:
    *
    * - Extract method
    * - Extract function
    * - Extract variable
    * - Extract interface from class
    * - ...
    */
  case object RefactorExtract extends CodeActionKind

  /**
    * Base kind for refactoring inline actions: 'refactor.inline'.
    *
    * Example inline actions:
    *
    * - Inline function
    * - Inline variable
    * - Inline constant
    * - ...
    */
  case object RefactorInline extends CodeActionKind

  /**
    * Base kind for refactoring rewrite actions: 'refactor.rewrite'.
    *
    * Example rewrite actions:
    *
    * - Convert JavaScript function to class
    * - Add or remove parameter
    * - Encapsulate field
    * - Make method static
    * - Move method to base class
    * - ...
    */
  case object RefactorRewrite extends CodeActionKind

  /**
    * Base kind for source actions: `source`.
    *
    * Source code actions apply to the entire file.
    */
  case object Source extends CodeActionKind

  /**
    * Base kind for an organize imports source action:
    * `source.organizeImports`.
    */
  case object SourceOrganizeImports extends CodeActionKind

  /**
    * Base kind for a 'fix all' source action: `source.fixAll`.
    *
    * 'Fix all' actions automatically fix errors that have a clear fix that
    * do not require user input. They should not suppress errors or perform
    * unsafe fixes such as generating new types or classes.
    *
    * @since 3.17.0
    */
  case object SourceFixAll extends CodeActionKind

}
