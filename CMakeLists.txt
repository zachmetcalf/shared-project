# Copyright (c) 2026 Zach Metcalf. All Rights Reserved.

cmake_minimum_required(VERSION 3.25)

project(shared_project LANGUAGES CXX VERSION 1.0)

set(SHARED_DIRECTORY ${PROJECT_SOURCE_DIR}/../shared CACHE PATH "shared directory")

add_subdirectory(${SHARED_DIRECTORY} shared)
