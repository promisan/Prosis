<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfparam name="Attributes.Message"          default="Error in Date">
<cfparam name="Attributes.AllowBlank"       default="True">
<cfparam name="Attributes.DateValidStart"   default="19500101">
<cfparam name="Attributes.DateValidEnd"     default="20500101">
<cfparam name="Attributes.Script"           default="">
<cfparam name="Attributes.ScriptDate"       default="">
<cfparam name="Attributes.Class"            default="regular">
<cfparam name="Attributes.Id"               default="#Attributes.FieldName#">
<cfparam name="Attributes.Manual"           default="true">
<cfparam name="Attributes.Calendar"         default="show">
<cfparam name="Attributes.InLine"           default="false">
<cfparam name="Attributes.onError"          default="">
<cfparam name="Attributes.Disabled"         default="">
<cfparam name="Attributes.OnKeyUp"          default="">
<cfparam name="Attributes.OnChange"         default="">
<cfparam name="Attributes.startLabel"       default="">
<cfparam name="Attributes.endLabel"         default="">
<cfparam name="Attributes.Position"         default="horizontal">
<cfparam name="Attributes.Ajax"         	default="No">

<cf_input
       name           = "#Attributes.Id#"
       type           = "dateRangePicker"
       DateValidStart = "#Attributes.DateValidStart#"
       DateValidEnd   = "#Attributes.DateValidEnd#"
       ajax           = "#Attributes.ajax#"
       startLabel     = "#attributes.startLabel#"
       endLabel       = "#attributes.endLabel#"
       OnChange       = "#Attributes.OnChange#"
       Position       = "#Attributes.Position#">
