#pragma once

namespace stl
{
	using namespace SKSE::stl;
}

namespace Papyrus
{
	using VM = RE::BSScript::Internal::VirtualMachine;
	using StackID = RE::VMStackID;
	using Severity = RE::BSScript::ErrorLogger::Severity;

	inline constexpr auto script = "JZCL_SISQFunctions"sv;

#define BIND(a_method, ...) a_vm.RegisterFunction(#a_method##sv, script, a_method __VA_OPT__(, ) __VA_ARGS__)
#define BIND_EVENT(a_method, ...) a_vm.RegisterFunction(#a_method##sv, obj, a_method __VA_OPT__(, ) __VA_ARGS__)

#define STATIC_ARGS [[maybe_unused]] VM *a_vm, [[maybe_unused]] StackID a_stackID, RE::StaticFunctionTag *
#define PASS_STATIC_ARGS a_vm, a_stackID, nullptr
}
