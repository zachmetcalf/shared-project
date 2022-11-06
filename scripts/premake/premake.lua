----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- premake.lua
--
-- Zach Metcalf
----------------------------------------------------------------------------------------------------------------------------------------------------------------

newoption {
    trigger = "project",
    description = "project",
}

newoption {
    trigger = "3rdparty",
    description = "3rdparty directory",
}

newoption {
    trigger = "shared",
    description = "shared directory",
}

newaction {
    trigger = "clean",
    description = "clean",
    execute = function()
        os.remove(path.join(_OPTIONS["project"], "shared_project.sln"))
        os.rmdir(path.join(_OPTIONS["project"], "bin"))
        os.rmdir(path.join(_OPTIONS["project"], "build"))
        os.rmdir(path.join(_OPTIONS["project"], "shared_project.xcworkspace"))
    end
}

package.path = package.path .. ";" .. path.join(path.join(_OPTIONS["shared"], "scripts"), "?.lua")

require "premake.demos.console_demo"
require "premake.demos.imgui_demo"
require "premake.demos.test_demo"
require "premake.interfaces.workspace"
require "premake.libraries.cpprest_ext"
require "premake.libraries.curl_ext"
require "premake.libraries.rapidjson_ext"
require "premake.libraries.shared"
require "premake.libraries.slack_ext"

platform = os.host();

workspace "shared_project"
    SetupWorkspace()

group "libraries"

project "cpprest_ext"
    BuildCppRestExt()

project "curl_ext"
    BuildCurlExt()

project "rapidjson_ext"
    BuildRapidJsonExt()

project "shared"
    BuildShared()

project "slack_ext"
    BuildSlackExt()

group "demos"

project "console_demo"
    SetupConsoleDemoProject()

project "imgui_demo"
    SetupImGuiDemoProject()

project "test_demo"
    SetupTestDemoProject()

group ""
