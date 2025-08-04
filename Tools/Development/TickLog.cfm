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
<cfparam name="Attributes.Init"   default = GetTickCount()>
<cfparam name="Attributes.Step"   default = "0">
<cfparam name="Caller.ThisTick"   default = "0">
<cfparam name="Attributes.Memo"   default = "">
<cfparam name="Operational"       default = "0">

<cfset ThisTick =GetTickCount()>
<cfset lineBreak = Chr(13) & Chr(10)>

<cfif operational eq "1">
	
	<cfsilent>
	<cfif Attributes.Step neq "0">
		 
		<cf_logpoint mode="append" fileName="Thick.txt">
			<cfoutput>
				#lineBreak#
				From start: #ThisTick - Attributes.Init# milisecs Step: #Attributes.Step#
				#lineBreak#
				From previous: #ThisTick - caller.PreviousTick# milisecs
				#lineBreak#			
				Memo :  #Attributes.Memo# 			
			</cfoutput>
		</cf_logpoint>
		
	<cfelse>
	
		<cf_logpoint fileName="Thick.txt">
		
			<cfoutput>
				#lineBreak#			
				From start: #ThisTick - Attributes.Init# milisecs Step: #Attributes.Step#
				#lineBreak#
				From previous : #ThisTick - caller.PreviousTick# milisecs
				#lineBreak#			
				Memo :  #Attributes.Memo#
			</cfoutput>
			
		</cf_logpoint>		
		
	</cfif>
			
	</cfsilent>

</cfif>

<cfset caller.PreviousTick = ThisTick>			