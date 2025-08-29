<!--
    Copyright © 2025 Promisan B.V.

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
<cfquery name="Text" 
	datasource="AppsInit">
		  UPDATE InterfaceText
		  SET    TextENG = '#url.eng#',
		         TextFRA = '#url.fra#', 
			     TextESP = '#url.esp#',
			     TextGER = '#url.ger#',
			     TextNED = '#url.ned#',
			     TextPOR = '#url.por#',
				 TextCHI = N'#url.chi#',
				 TextITA = '#url.ita#' 
		  WHERE  TextClass = '#url.cls#'
		  AND    TextId    = '#url.clsid#'
</cfquery>

<cfloop index="itm" list="ENG,FRA,ESP,GER,NED,POR,ITA,CHI">
	<cftry>
       <cfset StructDelete(Application["#itm#"], "#url.clsid#", "True")>
	   <cfcatch></cfcatch>
	</cftry>  	  
</cfloop>

<cfoutput>

<cfif url.box neq "">

	<script language="JavaScript">
	  opener._cf_loadingtexthtml=''; 
	  opener.ColdFusion.navigate('#SESSION.root#/tools/language/TL_update.cfm?cls=#url.cls#&clsid=#url.clsid#','#url.box#')	 
	  window.close()
	</script>
	
<cfelse>
	<script language="JavaScript">
	 window.close()
	</script> 

</cfif>	

</cfoutput>
