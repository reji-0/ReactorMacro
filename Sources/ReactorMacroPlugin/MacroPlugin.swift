import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct ReactorMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        /// State
        LoadingStateMacro.self,
        ErrorStateMacro.self,
        RefreshStateMacro.self,
        /// Mutation
        LoadingMutationMacro.self,
        ErrorMutationMacro.self,
        RefreshMutationMacro.self,
        /// Action
        InitializeActionMacro.self,
        RefreshActionMacro.self,
        /// Mutation + State
        LoadingSupportMacro.self,
        ErrorSupportMacro.self,
        RefreshSupportMacro.self,
        /// Composition
        CompositionSupportMacro.self,
        CompositionActionMacro.self,
        CompositionStateMacro.self,
        CompositionMutationMacro.self,
        /// Reduce
        GenerateReduceMacro.self,
    ]
}
