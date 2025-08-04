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

<cfset doc = replace(url.documentamount,',','',"ALL")>
<cfset tax = replace(url.tax,',','',"ALL")>

<cfif doc eq "">
   <cfset doc = 0>
</cfif>

<cfif tax eq "">
    <cfset tax = 0>
</cfif>

<cftry>

		<cfset amt = doc*100/(100+tax)>
	
	<cfcatch>
	
		<cfset amt = 0>
	
	</cfcatch>
	
</cftry>	

<cfoutput>
	
	<input type="Text"
		 name       = "amountpayable"
	     id         = "amountpayable"
         message    = "Enter a valid amount"
		 validate   = "float"
		 required   = "Yes"
		 readonly
		 value      = "#numberformat(amt,',.__')#"
		 visible    = "Yes"
		 enabled    = "Yes"		  
		 size       = "15"
		 class      = "regularxxl"
		 maxlength  = "15"
		 style      = "width:160px;background-color:f4f4f4;border:1px solid silver;font-size:17px;text-align:right;padding-right:2px">
	
	<cfif url.tag eq "Yes">
		<script>
			tagging('#amt#')
		</script>  
	</cfif>
		  
</cfoutput>		  