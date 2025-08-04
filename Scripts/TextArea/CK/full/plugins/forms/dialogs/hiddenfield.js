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
﻿/*
 Copyright (c) 2003-2021, CKSource - Frederico Knabben. All rights reserved.
 For licensing, see LICENSE.md or https://ckeditor.com/legal/ckeditor-oss-license
*/
CKEDITOR.dialog.add("hiddenfield",function(c){return{title:c.lang.forms.hidden.title,hiddenField:null,minWidth:350,minHeight:110,getModel:function(a){return(a=a.getSelection().getSelectedElement())&&a.data("cke-real-element-type")&&"hiddenfield"==a.data("cke-real-element-type")?a:null},onShow:function(){var a=this.getParentEditor(),b=this.getModel(a);b&&(this.setupContent(a.restoreRealElement(b)),a.getSelection().selectElement(b))},onOk:function(){var a=this.getValueOf("info","_cke_saved_name"),b=
this.getParentEditor(),a=CKEDITOR.env.ie&&8>CKEDITOR.document.$.documentMode?b.document.createElement('\x3cinput name\x3d"'+CKEDITOR.tools.htmlEncode(a)+'"\x3e'):b.document.createElement("input");a.setAttribute("type","hidden");this.commitContent(a);var a=b.createFakeElement(a,"cke_hidden","hiddenfield"),c=this.getModel(b);c?(a.replace(c),b.getSelection().selectElement(a)):b.insertElement(a);return!0},contents:[{id:"info",label:c.lang.forms.hidden.title,title:c.lang.forms.hidden.title,elements:[{id:"_cke_saved_name",
type:"text",label:c.lang.forms.hidden.name,"default":"",accessKey:"N",setup:function(a){this.setValue(a.data("cke-saved-name")||a.getAttribute("name")||"")},commit:function(a){this.getValue()?a.setAttribute("name",this.getValue()):a.removeAttribute("name")}},{id:"value",type:"text",label:c.lang.forms.hidden.value,"default":"",accessKey:"V",setup:function(a){this.setValue(a.getAttribute("value")||"")},commit:function(a){this.getValue()?a.setAttribute("value",this.getValue()):a.removeAttribute("value")}}]}]}});