#!/bin/bash

#  projectSpecificMustachebuildTests.sh
#  GRMustache.swift
#
#  Created by Vadim Eisenberg on 07/02/2016.
#  Copyright © 2016 IBM. All rights reserved.

cp Tests/Public/*/*.mustache .build/debug/
cp Tests/Public/*/*.text .build/debug/
cp -r Tests/vendor/groue/GRMustacheSpec/Tests .build/debug/
cp -r Tests/Public/TwitterHoganJSTests/HoganSuite .build/debug/
cp -r Tests/Public/TemplateRepositoryBundleTests/TemplateRepositoryBundleTests .build/debug/
cp -r Tests/Public/TemplateRepositoryBundleTests/TemplateRepositoryBundleTests_partial .build/debug/
cp -r Tests/Public/TemplateRepositoryBundleTests/TemplateRepositoryBundleTestsResources .build/debug/
cp -r Tests/Public/ServicesTests/LocalizerTestsBundle .build/debug/
cp -r Tests/Public/TemplateRepositoryFileSystemTests/TemplateRepositoryFileSystemTests .build/debug/
cp -r Tests/Public/TemplateRepositoryFileSystemTests/TemplateRepositoryFileSystemTests_* .build/debug/
