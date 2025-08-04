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

<cf_screentop height="100%" 
    label="User Account" 
	scroll="yes" 
	jquery="Yes" 
	user="no"
	html="No"
	close="parent.ColdFusion.Window.destroy('userdialog',true)"
	layout="webapp" 	
	banner="gray">
	
<!--- Query returning search results --->

<cfparam name="Form.Page"     default="1">
<cfparam name="Form.Group"    default="LastName">
<cfparam name="URL.Page"      default="#Form.Page#">
<cfparam name="URL.ID4"       default="">
<cfparam name="URL.IDSorting" default="#Form.Group#">
<cfparam name="URL.Search"    default="">

<cfoutput>

<script>
	
	function sel(id,last,first) {
		
		<cfif url.form eq "Webdialog">
			
		{ 
		  returnValue = id+';'+last+';'+first+';'+first+' '+last
		  window.close()		  
		}
		
		<cfelse>
		
		    var form     = "#URL.Form#";
			var fldid    = "#URL.id#";
			var fldlast  = "#URL.id1#";
			var fldfirst = "#URL.id2#";
			var fldname  = "#URL.id3#";			
			parent.document.getElementById(fldid).value = id				
			try {
			parent.document.getElementById(fldlast).value  = last } catch(e) {}
			try {
			parent.document.getElementById(fldfirst).value = first } catch(e) {}
			try {
			parent.document.getElementById(fldname).value =  first+' '+last } catch(e) {}			
			parent.ProsisUI.closeWindow('userdialog',true);
			
		</cfif>	
	}
	
	function process(acc,formgoto) {
		  	
		if (formgoto == "rosteraccess") {
		    window.location="#SESSION.root#/Roster/Maintenance/Access/UserAccess.cfm?ID=#URL.ID#&ID1=#URL.ID1#&ACC=" + acc;
		} else {
			if (formgoto == "stepfly") {
			    window.location="#SESSION.root#/Tools/EntityAction/ProcessActionAccess.cfm?ID=#URL.ID#&ID1=#URL.ID1#&ACC=" + acc;
			} else {
				if (formgoto == "programindicator") {		
				    window.location="#SESSION.root#/ProgramREM/Application/Program/Indicator/TargetFlyAccess.cfm?TargetId=#URL.ID#&Role=#URL.ID1#&i=#URL.ID2#&ACC=" + acc
				} else {				  
				  window.location="#SESSION.root#/System/Organization/Access/UserAccess.cfm?ID=#URL.ID#&ID1=#URL.ID1#&ID2=#URL.ID2#&Mission=#URL.ID3#&ID4=#URL.ID4#&ACC=" + acc 
					}
				}
			}
		}
	
	function reloadForm(group,page) {
	     window.location="UserResult.cfm?Form=#URL.Form#&ID=#URL.ID#&ID1=#URL.ID1#&ID2=#URL.ID2#&ID3=#URL.ID3#&ID4=#URL.ID4#&IDSorting=" + group + "&Page=" + page;
	}

</script>	

</cfoutput>

<!--- Query returning search results --->

<cfquery name="SearchResult" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM  UserNames 
WHERE 1=1
<cfif Session.usersearchcriteria neq "">
AND   #PreserveSingleQuotes(Session.usersearchcriteria)# 
</cfif>
<cfif URL.ID eq "Group">
	AND AccountType = 'Individual'  
</cfif>
ORDER BY #URL.IDSorting#
</cfquery>

<cfinvoke component="Service.Access"  
	   method="useradmin" 
	   returnvariable="access">	
   
<cf_dialogStaffing>

<table width="97%" height="100%" align="center">
  <tr>
    <td class="labelmedium" style="font-weight:300;padding-left:10px;font-size:20px;height:45">
	<cfoutput>			 
	<a href="javascript:ptoken.open('UserSearch.cfm?Form=#URL.Form#&ID=#URL.ID#&ID1=#URL.ID1#&ID2=#URL.ID2#&ID3=#URL.ID3#&ID4=#URL.ID4#','result')">
	<cf_tl id="Return to Search">
	</a>
	</cfoutput>
	</td>
	
    <td align="right">
		
	<select name="group" id="group" class="regularxl" size="1" onChange="javascript:reloadForm(this.value,page.value)">
	     <option value="AccountGroup" <cfif URL.IDSorting eq "AccountGroup">selected</cfif>>Order by Account group
	     <OPTION value="LastName"     <cfif URL.IDSorting eq "LastName">selected</cfif>>Order by Last name
	     <OPTION value="Account"      <cfif URL.IDSorting eq "Account">selected</cfif>>Order by Account name
	</SELECT> 
	
	&nbsp;

   <cfinclude template="../../../Tools/PageCount.cfm">
   <cfset no = 23>
   <cfif pages gt "1">
	<select name="page" id="page" class="regularxl" size="1" onChange="javascript:reloadForm(group.value,this.value)">
    <cfloop index="Item" from="1" to="#pages#" step="1">
        <cfoutput><option value="#Item#"<cfif URL.page eq "#Item#">selected</cfif>>Page #Item# of #pages#</option></cfoutput>
    </cfloop>	 
	</SELECT>&nbsp;
   <cfelse>
   <input type="hidden" name="page" id="page" value="1">	
   </cfif>	
		 
	 </td>
  </tr>
 
 <tr>

<td width="100%" colspan="2" height="100%">

	<cf_divscroll>

	<table width="100%" border="0">
	
	<td colspan="2">
	
		<table width="100%" align="center" class="navigation_table">
		
		<Tr class="fixrow labelmedium line">
		    <td></td>
		    <TD><cf_tl id="Account"></TD>
		    <TD><cf_tl id="Name"></TD>
		    <TD><cf_tl id="eMail"></TD>						
			<TD><cf_tl id="Created"></TD>
		    <TD></TD>
		</TR>
		
		<cfset currrow = 0>
		
		<CFOUTPUT query="SearchResult" group="#URL.IDSorting#" startrow="#first#">
		
		   <cfif currrow lt No>   
		   
		   <cfswitch expression = "#URL.IDSorting#">
		     <cfcase value = "AccountGroup">
			 <tr class="labelmedium" height="24" bgcolor="f3f3f3">
		     <td colspan="8" style="padding-left:5px">#AccountGroup#</font></td>
			 </tr>
		     </cfcase>
		     <cfcase value = "LastName"></cfcase>	 
		     <cfcase value = "Account">
		     <!--- <td colspan="8"><font face="Tahoma" size="2"><b>&nbsp;#Dateformat(TransactionDate, "#CLIENT.DateFormatShow#")#</b></font></td> --->
		     </cfcase>
		     <cfdefaultcase>
			 <tr bgcolor="E8E8CE">
		     <td colspan="8" style="padding-left:5px">#AccountGroup#</td>
			 </tr>
		     </cfdefaultcase>
		   </cfswitch>
		      
		   </cfif>
		
		   <cfoutput>
		   
		   <cfset currrow = currrow + 1>
		
		   <cfif currrow lte No>
		   
		   <TR style="height:24px" bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('fbfbfb'))#" class="labelmedium navigation_row line">  
			   <td width="5%" align="center" style="padding-top:4px">   	   
				    <cfif URL.ID3 eq "Lookup">				
						<cf_img icon="select" navigation="Yes" onClick="sel('#Account#','#LastName#','#FirstName#')">		
					<cfelse>				
						<cf_img icon="select" navigation="Yes" onClick="process('#URLEncodedFormat(Account)#','#URL.Form#')">		 
					</cfif> 	   
			   </td>		
			   <TD style="min-width:80;padding-left:6px;padding-right:10px"> <cfif accounttype eq "group"></cfif>
			      <cfif Access eq "EDIT" or Access eq "ALL">
			       <a href="javascript:ShowUser('#URLEncodedFormat(Account)#')">#Account#</a>
				  <cfelse>
				  #Account# 
			      </cfif>
			   </TD>	   
			   <cfif AccountType eq "Individual">
				   <TD width="35%"><A style="padding-right:5px" HREF ="javascript:ShowPerson('#IndexNo#')">#IndexNo#</a>#LastName#, #FirstName#</TD>	   
				   <TD width="25%" style="padding-right:8px"><cfif eMailAddress neq "">
					   <a href="javascript:email('#eMailAddress#','','','','User','#Account#')">
					   </cfif>#eMailAddress#
				   </TD>	
				  
			   <cfelse>
			      <TD colspan="2" width="85%">#LastName#</TD>
			   </cfif>	      			   			   
			   <td style="padding-right:5px">#DateFormat(Created, CLIENT.DateFormatShow)#</td>	   
			   <td align="center">
			   <!--- <input type="checkbox" name="Account" value="'#Account#'" onClick="hl(this,this.checked)"> --->
			   </td>
		        
		   </TR>
		   	
		   </cfif>
		
		   </cfoutput>
		   
		</cfoutput>
		
	</TABLE>
		
	</cf_divscroll>
		
		</td>
		</tr>
		
	</TABLE>
</td>
</table>



<cf_screenbottom layout="webapp">

<cfset ajaxonload("doHighlight")>