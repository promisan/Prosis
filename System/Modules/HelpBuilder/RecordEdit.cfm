<cfparam name="URL.ID" default="">
<cfparam name="URL.IDMenu" default="">

<cfquery name="Get" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   HelpProjectTopic
	WHERE  ProjectCode = '#URL.Code#'
	<cfif URL.ID neq "">
	AND   TopicId     = '#URL.ID#'
	<cfelse>
	AND   1=0
	</cfif>
	AND   LanguageCode  = '#Client.Languageid#' 
</cfquery>

<cfoutput>

<cf_textareascript>

<cfif url.id neq "">
<cf_screentop jquery="Yes" banner="red"   bannerforce="Yes"  layout="webapp" scroll="Yes" label="#URL.Code#|#URL.Class#: Help Project Topic" doctype="HTML5">
<cfelse>
<cf_screentop jquery="Yes" banner="green" bannerforce="Yes"  layout="webapp" html="Yes" scroll="Yes" label="#URL.Code#|#URL.Class#: Help Project Topic" doctype="HTML5">
</cfif>
	
<table width="99%" height="100%" align="center" cellspacing="0" cellpadding="0"">

<tr><td colspan="2" style="height:100%;padding:10px">

	<cfform style="height:100%" action="RecordSubmit.cfm?module=#url.module#&idmenu=#URL.idmenu#&code=#URL.code#&class=#URL.class#&id=#URL.ID#" method="POST" target="process" name="dialog">

	<cf_divscroll style="height:100%">
		
	<!--- Entry form --->
	
	<table width="98%" align="center" class="formpadding formspacing">
			
		<tr class="hide">
			<td><iframe name="process" id="process"></iframe></td>
		</tr> 
	
	    <tr><td height="6"></td></tr>
	    				
		<TR>
		    <TD class="labelmedium"><cf_tl id="Topic">:</TD>
		    <TD class="labelit">
			   <table cellspacing="0" cellpadding="0">
			   <tr>
				   <td class="labelit">
			  	   <cfinput type="Text" name="TopicName" value="#Get.TopicName#" message="Please enter a description" required="Yes" size="60" maxlength="60" class="regularxl enterastab">
				   </td>
				   <!---
				   <TD class="labelit" style="padding-left:20px">Listing order:&nbsp;</TD>
			       <TD>
			  	   <cfinput type="Text" name="ListingOrder" value="#Get.ListingOrder#" message="Please enter a valid order" validate="integer" required="No" visible="Yes" enabled="Yes" size="3" maxlength="3" class="regularxl">
			       </TD>
				   --->
			   </tr>
			   </table>
		    </TD>
		</TR>		
		
		<TR>
	    <TD width="150" class="labelmedium">Code: <font size="3">#URL.Code#-</TD>
		<TD class="labelit">				
		  
			  	   <cfinput type="Text" name="TopicCode" value="#Get.TopicCode#" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxl enterastab">
								
				   <!---
				   <img src="<cfoutput>#SESSION.root#</cfoutput>/images/finger.gif" alt="" border="0" align="absmiddle">
					The <b>Identifier</b> needs to be coordinated with the application developer to ensure content senstive help</td>
				   --->		
				
					<cfquery name="Language" 
					 datasource="AppsSystem"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					 SELECT  *
					 FROM    Ref_SystemLanguage
					 WHERE   Operational IN ('1','2')
					</cfquery> 				 		
				
	    </TD>
		</TR>		
		
		<tr>
			<TD class="labelmedium" width="70"><cf_tl id="Language">:</TD>
			<TD class="labelit">
				<select name="LanguageCode" id="LanguageCode" class="regularxl enterastab">
				  <cfloop query="Language">
				  <option value="#Code#" 
				      <cfif Code eq "#get.LanguageCode#">selected</cfif>>#LanguageName#</option>
				  </cfloop>
				</select>
			</td>
		</tr>					
					
		<TR>
			<TD class="labelmedium"><cf_tl id="Label">:</TD>
		    <TD class="labelit">
		  	   <cfinput type="Text" name="UITextHeader" value="#Get.UITextHeader#" size="70" maxlength="80" class="regularxl enterastab">			   
		    </TD>
		</TR>	
		
		<tr>
			<TD class="labelmedium" width="90"><cf_tl id="Presentation">:</TD>
			<TD class="labelit">
			
			<table cellspacing="0" cellpadding="0">
			<tr>
			<td class="labelit">
				<select name="TopicPresentation" id="TopicPresentation" class="regularxl enterastab">
				  <option value="Embed"  <cfif get.TopicPresentation eq "Embed">selected</cfif>>Embed</option>
				  <option value="Dialog"  <cfif get.TopicPresentation eq "Dialog">selected</cfif>>Window</option>
				  <option value="Modal"   <cfif get.TopicPresentation eq "Modal">selected</cfif>>Modal Dialog</option>
				  <option value="Tooltip" <cfif get.TopicPresentation eq "Tooltip">selected</cfif>>Help Slider</option>				
				</select>
			</td>				
			
			<TD style="padding-left:10px">
			
			        <table><tr>

					<td><input name="UITextHeaderIcon" id="UITextHeaderIcon" class="enterastab" type="radio" value="" <cfif Get.UITextHeaderIcon eq "">checked</cfif>></td>
					<td class="labelmedium" style="padding-left:4px">Default</td>
																
					<cfloop index="icn" list="help1.png,help2.png,help3.png" delimiters=",">
						<td style="padding-left:4px">
							<input name="UITextHeaderIcon" id="UITextHeaderIcon" type="radio" class="enterastab" value="#icn#" <cfif Get.UITextHeaderIcon eq icn>checked</cfif>>
						</td>
						<td style="padding-left:4px">
							<img src="#SESSION.root#/Images/#icn#" align="absmiddle" alt="" border="0">		
						</td>
					</cfloop> 
					
					</tr></table>
				
			</TD>
			</tr>
			</table>
			</td>
		</tr>		
					
		<script language="JavaScript">
		
			function source(val) {
		
				se = document.getElementById("robo");
				se1 = document.getElementById("robo1");
				if (val == "local") { 
				    se.className = "hide";
				    se1.className = "hide";
				} else {
				    se.className = "regular";
				    se1.className = "regular";
				}  
			}	
			
		</script>
				
		<cfif Get.UITextSource eq "Robohelp">
		 <cfset cl = "regular">
		<cfelse>
		 <cfset cl = "hide">
		</cfif>
				
		<!---
		
		<TR>
	    <TD width="60">Location:</TD>
	    <TD>
		
		<table border="0" cellspacing="0" cellpadding="0"><tr>
		<td><input type="radio" name="Source" value="local" <cfif  #Get.UITextSource# eq "Local" or #Get.UITextSource# eq "">checked</cfif> onclick="javascript:source('local')"></td>
		<td>#SESSION.welcome#</td>
		<td>
		&nbsp;
		<input type="radio" name="Source" disabled value="robohelp" onclick="javascript:source('robo')" <cfif  #Get.UITextSource# eq "robohelp">checked</cfif>>
		<img src="<cfoutput>#SESSION.root#</cfoutput>/images/robohelp.gif" alt="Robohelp" border="0" align="absmiddle">
		</td>
		<td>
		Robohelp
		</td>
		<td id="robo" class="<cfoutput>#cl#</cfoutput>">
		Id:
		</td>
		<td id="robo1" class="<cfoutput>#cl#</cfoutput>">
		<cfinput type="Text" name="UITextProjectFileId" value="#Get.UITextProjectFileId#" validate="integer" required="No" visible="Yes" enabled="Yes" size="3" maxlength="3" class="regular">
		</td>
		</TR>
		</table>
		
		</td>
		</tr>
		
		--->
		
		<tr class="regular" id="local">
		
			<td colspan="2" valign="top">
			
				<table width="100%" cellspacing="0" cellpadding="0">					
				
				<cfloop index="itm" list="Question,Answer" delimiters=",">				
							
					<tr><td class="labelit" style="height:40px;padding-top:10px;font-size:15px" colspan="2" height="50" width="100"><cfoutput>#itm#</cfoutput> body:</td></tr>
					
					<tr>
					<td colspan="2" valign="top" height="190">
						<cf_textarea name="#itm#" color="ffffff" toolbar="basic" height="170" resize="false" init="yes"><cfoutput>#evaluate("get.UIText#itm#")#</cfoutput></cf_textarea>										
					</td>
					</tr>					
				
				</cfloop>
				
				</table>		
			
			</td>
			
		</tr>	
							
		<tr>
			
			<td colspan="2" align="center" height="36">
					   
				<cfif URL.ID neq "">
				<input class="button10g" type="button" name="Back" id="Back" value="Close" onclick="window.close()">
				<input class="button10g" type="submit" name="Delete" id="Delete" value="Delete" onclick="Prosis.busy('yes')">
				<cfelse>
				<!---
				<input class="button10g" type="button" name="Back" id="Back" value="Back" onclick="history.back()">
				--->
				</cfif>
				<input class="button10g" type="submit" name="Submit" id="Submit" value="Save" >
				</td>	
		</tr>
			
	</TABLE>
	
	</cf_divscroll>
	
	</CFFORM>
		
	</td>
</tr>	
	
</table>	

<cf_screenbottom layout="webapp">

<cfset ajaxonload("doTextarea")>

</cfoutput>

