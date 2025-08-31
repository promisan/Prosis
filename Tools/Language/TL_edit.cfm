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
<cf_screentop height="100%" label="Set #url.cls# / #url.clsid#" user="no" layout="webapp" background="red">

<cfajaximport>

<cfquery name="Text" 
		  datasource="AppsInit">
		  SELECT * 
		  FROM  InterfaceText
		  WHERE TextClass = '#url.cls#'
		  AND   TextId      = '#url.clsid#'
</cfquery>

<cfoutput>

<cfparam name="url.box" default="">

<table width="92%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<tr><td height="8"></td></tr>
	
	<cfset list = "ENG,ESP,FRA,GER,NED,POR,ITA,CHI">
			 
	<cfloop index="itm" list="#list#" delimiters=",">
		
		<tr class="labelmedium">
		  <td width="60">#Itm#:</td>
		  <td width="90%">
		  <cfif url.cls neq "Message">
		  
		  		<input type="text"
			       name="text#Itm#"
				   id="text#Itm#"
			       value="#evaluate('Text.Text#Itm#')#"
		    	   style="width:98%"
				   class="regularxl"
			       maxlength="80">
				   
		  <cfelse>
		  
		  		<textarea rows="2"
				 class="regular"
		         name="Text#Itm#"
		         style="width:98%;font-size:13px;padding:3px">#evaluate('Text.Text#Itm#')#
			    </textarea>	
		  
		  </cfif>	   
			   
		  </td>
		</tr>
	
	</cfloop>		 
	
	<script language="JavaScript">
		
		function save() {			
			url = "TL_editSave.cfm?box=#url.box#&cls=#url.cls#&clsid=#URL.clsid#"+
			"&eng="+document.getElementById("textENG").value+
			"&fra="+document.getElementById("textFRA").value+
			"&esp="+document.getElementById("textESP").value+
			"&ger="+document.getElementById("textGER").value+
			"&ned="+document.getElementById("textNED").value+
			"&por="+document.getElementById("textPOR").value+
			"&chi="+document.getElementById("textCHI").value+
			"&ita="+document.getElementById("textITA").value
			ColdFusion.navigate(url,'process')	
		}
	
	</script>
	
	<tr><td id="process"></td></tr>
				
	<tr><td colspan="2" height="30" align="center" id="select" style="padding-top:2px">
	<input type="button" name="Cancel" id="Cancel" value="Close" class="button10g" onclick="window.close()">
	<input type="button" name="Save" id="Save" value="Save" class="button10g" onclick="save()">
	</td></tr>
	
</table>

</cfoutput>
