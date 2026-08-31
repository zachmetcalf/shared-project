# Copyright (c) 2026 Zach Metcalf. All Rights Reserved.

cmake_minimum_required(VERSION 3.25)

project(shared_project LANGUAGES CXX VERSION 1.0)

set(SHARED_DIRECTORY ${PROJECT_SOURCE_DIR}/../shared CACHE PATH "shared directory")

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${SHARED_DIRECTORY}/scripts/cmake)

include(shared_macros)
include(tools/sccache)

shared_enable_sccache()

add_subdirectory(${SHARED_DIRECTORY} shared)
