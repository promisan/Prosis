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
<!--- Prosis template framework --->
<cfsilent>
	<proUsr>dev</proUsr>
	<proOwn>dev dev</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<!--- End Prosis template framework --->


<cfquery name="Purchase" 
 datasource="AppsPurchase">
 SELECT *
 FROM Purchase P
 WHERE PurchaseNo = '#URL.PurchaseNo#' 
</cfquery>

<cfquery name="Clause" 
 datasource="AppsPurchase">
 SELECT *
 FROM PurchaseClause
 WHERE PurchaseNo = '#URL.PurchaseNo#' 
 AND ClauseCode = '#URL.ClauseCode#' 
</cfquery>

<cfoutput query="Clause">

<cfdocument 
          format="PDF"
          pagetype="letter"
          margintop="0.5"
          marginbottom="0.5"
          marginright="0.5"
          marginleft="0.5"
          orientation="portrait"
          unit="cm"
          encryption="none"
          fontembed="Yes"
          scale="100"
          backgroundvisible="No">

<table width="100%">
<tr>
   <td style="font-size: xx-small;"><cf_tl id="PurchaseNo"></td>
   <td style="font-size: xx-small;">#Purchase.PurchaseNo#</td>
</tr>
<tr>
   <td style="font-size: xx-small;"><cf_tl id="Created"></td>
   <td style="font-size: xx-small;">#DateFormat(Purchase.Created, CLIENT.DateFormatShow)#</td>
</tr>

<tr><td height="1" colspan="2" class="line"></td></tr>
<tr><td colspan="2"></td></tr>
</table>

<div style="font: x-small;">

<cfset text = #replace("#ClauseText#", "@pb", "<cfdocumentitem type = 'pagebreak'/>", "ALL")#>
	
<cftry>				
	  <cffile action = "delete"
	  file = "#SESSION.rootpath#\CFRStage\user\#SESSION.acc#\#SESSION.acc#readme.cfm"> 
	  <cfcatch></cfcatch>
</cftry>	  
						    
<cffile action = "append"
	     file = "#SESSION.rootpath#\CFRStage\user\#SESSION.acc#\#SESSION.acc#readme.cfm"
         output = "#text#"
         addNewLine = "Yes">  
			 
<cfinclude template="../../../../CFRStage/user/#SESSION.acc#/#SESSION.acc#readme.cfm">

<cffile action = "delete"
	 	  file = "#SESSION.rootpath#/CFRStage/user/#SESSION.acc#/#SESSION.acc#readme.cfm">  
		  
</div>		  
	
</cfdocument>

</cfoutput>

</body>
