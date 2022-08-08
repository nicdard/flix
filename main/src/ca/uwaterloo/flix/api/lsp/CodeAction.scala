package ca.uwaterloo.flix.api.lsp

import org.json4s.JsonDSL._
import org.json4s._

/**
  * Represents a `CodeAction` in lsp.
  *
  * A code action represents a change that can be performed in code, e.g. to fix
  * a problem or to refactor code.
  *
  * A CodeAction must set either `edit` and/or a `command`. If both are supplied,
  * the `edit` is applied first, then the `command` is executed.
  *
  * @param title            A short, human-readable, title for this code action.
  * @param kind             The kind of the code action. Used to filter actions.
  * @param diagnostics      The diagnostics that this code action resolves.
  * @param isPreferred      Marks this as a preferred action. Preferred actions are used by the
  *                         `auto fix` command and can be targeted by keybindings.
  * @param edit             The workspace edit this code action performs.
  * @param command          A command this code action executes. If a code action
  *                         provides an edit and a command, first the edit is
  *                         executed and then the command.
  */
case class CodeAction(title: String,
                      kind: Option[CodeActionKind],
                      diagnostics: List[Diagnostic],
                      isPreferred: Boolean,
                      // disabledReason: Option[String],
                      edit: Option[WorkspaceEdit],
                      command: Option[Command]
                     ) {
  def toJson: JValue =
    ("title" -> title) ~
      ("kind" -> kind.map(_.toJson())) ~
      ("diagnostic" -> diagnostics.map(_.toJSON)) ~
      ("isPreferred" -> isPreferred) ~
      // ("disabled" -> disabledReason.map(JObject()))
      ("edit" -> edit.map(_.toJSON)) ~
      ("command" -> command.map(_.toJSON))
}
