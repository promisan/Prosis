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

<cfparam name="attributes.Warehouse"            default="">
<cfparam name="Attributes.TransactionDate"      default="#DateFormat(now(), CLIENT.DateFormatShow)#">
<cfparam name="Attributes.TransactionTime"      default="#TimeFormat(now(), 'HH:MM')#">

<!--- Instatiating time object object--->
<cfset oTimer = CreateObject("component","Service.Process.Materials.WarehouseTime")/>

<cfset s = oTimer.getTime(Attributes.TransactionDate, Attributes.TransactionTime, Attributes.Warehouse)>

<cfset caller.localtime    = s.localtime>
<cfset caller.timezone     = s.timezone>
<cfset caller.tzcorrection = s.tzcorrection>


	




