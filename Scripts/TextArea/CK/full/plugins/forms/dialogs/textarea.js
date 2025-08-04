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
CKEDITOR.dialog.add("textarea",function(b){return{title:b.lang.forms.textarea.title,minWidth:350,minHeight:220,getModel:function(a){return(a=a.getSelection().getSelectedElement())&&"textarea"==a.getName()?a:null},onShow:function(){var a=this.getModel(this.getParentEditor());a&&this.setupContent(a)},onOk:function(){var a=this.getParentEditor(),b=this.getModel(a),c=this.getMode(a)==CKEDITOR.dialog.CREATION_MODE;c&&(b=a.document.createElement("textarea"));this.commitContent(b);c&&a.insertElement(b)},
contents:[{id:"info",label:b.lang.forms.textarea.title,title:b.lang.forms.textarea.title,elements:[{id:"_cke_saved_name",type:"text",label:b.lang.common.name,"default":"",accessKey:"N",setup:function(a){this.setValue(a.data("cke-saved-name")||a.getAttribute("name")||"")},commit:function(a){this.getValue()?a.data("cke-saved-name",this.getValue()):(a.data("cke-saved-name",!1),a.removeAttribute("name"))}},{type:"hbox",widths:["50%","50%"],children:[{id:"cols",type:"text",label:b.lang.forms.textarea.cols,
"default":"",accessKey:"C",style:"width:50px",validate:CKEDITOR.dialog.validate.integer(b.lang.common.validateNumberFailed),setup:function(a){a=a.hasAttribute("cols")&&a.getAttribute("cols");this.setValue(a||"")},commit:function(a){this.getValue()?a.setAttribute("cols",this.getValue()):a.removeAttribute("cols")}},{id:"rows",type:"text",label:b.lang.forms.textarea.rows,"default":"",accessKey:"R",style:"width:50px",validate:CKEDITOR.dialog.validate.integer(b.lang.common.validateNumberFailed),setup:function(a){a=
a.hasAttribute("rows")&&a.getAttribute("rows");this.setValue(a||"")},commit:function(a){this.getValue()?a.setAttribute("rows",this.getValue()):a.removeAttribute("rows")}}]},{id:"value",type:"textarea",label:b.lang.forms.textfield.value,"default":"",setup:function(a){this.setValue(a.$.defaultValue)},commit:function(a){a.$.value=a.$.defaultValue=this.getValue()}},{id:"required",type:"checkbox",label:b.lang.forms.textfield.required,"default":"",accessKey:"Q",value:"required",setup:CKEDITOR.plugins.forms._setupRequiredAttribute,
commit:function(a){this.getValue()?a.setAttribute("required","required"):a.removeAttribute("required")}}]}]}});