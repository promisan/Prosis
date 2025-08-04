/*
 * Copyright © 2025 Promisan
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
﻿(function(){bender.loadExternalPlugin("exportpdf","/apps/plugin/");CKEDITOR.plugins.load("exportpdf",function(){bender.editors={defaultHeader:{config:{extraPlugins:"exportpdf"}},customHeader:{config:exportPdfUtils.getDefaultConfig("unit")}};bender.test({setUp:function(){bender.tools.ignoreUnsupportedEnvironment("exportpdf");sinon.stub(CKEDITOR.plugins.exportpdf,"downloadFile")},tearDown:function(){CKEDITOR.plugins.exportpdf.downloadFile.restore()},"test default statistics header":function(){var a=
this.editors.defaultHeader;this.editorBots.defaultHeader.setHtmlWithSelection('\x3cp id\x3d"test"\x3eHello, World!\x3c/p\x3e^');exportPdfUtils.useXHR(a,function(a){assert.areEqual(a.requestHeaders["x-cs-app-id"],"cke4","Default stats header is wrong.")})},"test custom statistics header":function(){var a=this.editors.customHeader;this.editorBots.customHeader.setHtmlWithSelection('\x3cp id\x3d"test"\x3eHello, World!\x3c/p\x3e^');exportPdfUtils.useXHR(a,function(a){assert.areEqual(a.requestHeaders["x-cs-app-id"],
"cke4-tests-unit","Custom stats header was not set properly.")})}})})})();