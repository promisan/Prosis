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
<cfsilent>
	<proUsr>dev</proUsr>
	<proOwn>dev dev</proOwn>
	<proDes>Prosis Use Case</proDes>
	<proCom>This file list all the use cases we have documented</proCom>
</cfsilent>
<!--- End Prosis template framework --->
<TITLE>View General</TITLE>

<div style="position:absolute;width:100%;height:100%; overflow: auto; scrollbar-face-color: F4f4f4;">

<cfoutput>

<script>
var root = "#root#";

function reloadForm(page,view,layout,sort) {
        window.location="FunctionListing.cfm?ID=#URL.ID#&Page=" + page + "&View=" + view + "&Lay=" + layout + "&Sort="+sort;
}
	
function ClassEdit(clid,dialog) {
    w = #CLIENT.width# - 90;
    h = #CLIENT.height# - 140;
	window.open(root + "/System/Parameter/FunctionClass/FunctionEdit.cfm?ID=" + clid + "&mode=" + dialog, "ClassEd", "left=40, top=40, width=" + w + ", height= " + h + ", status=yes, scrollbars=no, resizable=yes");
}
	

</script>

</cfoutput>

<cfparam name="URL.Sort" default="">
<cfparam name="URL.View" default="Hide">
<cfparam name="URL.Lay" default="Reference">
<cfparam name="URL.page" default="1">
<cfparam name="URL.Type" default="ALL">

<cfset counted = 0>
<cfoutput>

<cfquery name="QClass" 
datasource="AppsControl" 
username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     *
	FROM Class
	where ClassId='#URL.ID#'
</cfquery>


<cfquery name="QListing" 
datasource="AppsControl" 
username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     F.*, T.Name as TypeName
	FROM ClassFunction F,Ref_FunctionType T
	where ClassId='#URL.ID#'
		and (ClassFunctionCode is not null)
		and F.ClassFunctionType=T.Code
	<cfif #URL.Type# neq "ALL">
		and ClassFunctionType ='#URL.Type#'
	</cfif>
	order by created
</cfquery>


<cfif #URL.Type# neq "ALL">
	<cfquery name="Types" 
		datasource="AppsControl"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM    Ref_FunctionType
		Where Code='#URL.Type#'
	    ORDER BY ListingOrder
	</cfquery>
</cfif>

<cfset currrow = 0>
<cfset counted = #QListing.recordcount#>

		<table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="silver" class="formpadding">
		  <tr>
		    <td height="26">
			&nbsp;<b>#URL.ID#</b>
			<br>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#QClass.ClassMemo#
			
			<cf_filelibraryN 
				DocumentPath="Documentation"
				SubDirectory="#URL.ID#"
				Filter="" 
				Insert="yes"
				Remove="yes"
				width="99%"
				AttachDialog="yes"
				align="left"
				border="100"> 			
		
			</td>
			<td align="right">
			<button name="Add" id="Add" class="button10g" onclick="javascript:ClassAdd('#URL.ID#','dialog')" >Add Function</button>
			<!--- drop down to select only a number of record per page using a tag in tools --->	
           <cf_PageCountN count="#counted#">
           <select name="page" id="page" size="1" style="background: ffffff; color: 002350;"
           onChange="javascript:reloadForm(this.value,view.value,layout.value,mandate.value,mission.value)">
		   <cfloop index="Item" from="1" to="#pages#" step="1">
              <cfoutput><option value="#Item#"<cfif #URL.page# eq "#Item#">selected</cfif>>Page #Item# of #pages#</option></cfoutput>
           </cfloop>	 
           </SELECT> &nbsp;  	
				
		    </TD>
		  </tr>
		  <tr><td colspan="2" bgcolor="silver"></td></tr>
		<cfif #URL.Type# neq "ALL">
		<tr>
		<td colspan="2" height="35">
				&nbsp;<b>#Types.Name#</b><br>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#Types.Description#
		</td>
		</tr>
		  <tr><td colspan="2" bgcolor="silver"></td></tr>
		</cfif>
	  
								
		<tr><td colspan="2">
		
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
				
		<TR>
		    <td width="3%"></td>
		    <td width="13%" colspan="2"><b>Function Code</td>
		    <td width="30%"><b>Description</td>
			<TD width="30%"><b>Type</TD>
		    <td width="13%"><b>Date</td>
		</TR>
		<tr><td colspan="8" bgcolor="DFDFDF"></td></tr>
		
		<tr><td colspan="8">
								 
			<cfinclude template="Navigation.cfm"> 
							 
		</td></tr>
		
		<tr><td height="1" colspan="6" bgcolor="d4d4d4"></td></tr>
		
		<cfloop query="QListing">
		
		<cfquery name="Qcheck" 
		datasource="AppsControl" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT     COUNT(1) AS total
			FROM         ClassFunctionElement
			WHERE     (ClassFunctionId = '#QListing.ClassFunctionId#') AND (DATALENGTH(TextContent) <> 0)			
		</cfquery>		
		
		<cfif #QCheck.total# eq 0>
		   <tr bgcolor="C0C0C0" height="20">
		<cfelse>
		   <tr bgcolor="ffffff" height="20">
		</cfif>
			  	<td width="3%">
				 <img src="#SESSION.root#/Images/pointer.gif"
			     alt="Edit Function Class"
			     name="img0_#currentRow#"
			     width="9"
			     height="9"
			     border="0"
			     align="absmiddle"
			     style="cursor: pointer;"
			     onClick="javascript:ClassEdit('#QListing.ClassFunctionId#','dialog')"
			     onMouseOver="document.img0_#currentRow#.src='#SESSION.root#/Images/button.jpg'"
			     onMouseOut="document.img0_#currentRow#.src='#SESSION.root#/Images/pointer.gif'">				
				 
				</td>
			    <td width="13%" colspan="2"><a href="javascript:ClassEdit('#QListing.ClassFunctionId#','dialog')">#QListing.ClassFunctionCode#</a></td>
			    <td width="30%"><a href="javascript:showdetail('#QListing.ClassFunctionId#')">#QListing.FunctionDescription#</a></td>
				<td width="30%">#QListing.TypeName#</TD>
	   		    <td width="11%">#DateFormat(QListing.Created, CLIENT.DateFormatShow)#</td>
		   </tr>
		   <tr><td height="1" colspan="6" bgcolor="d4d4d4"></td></tr>
		</cfloop>
							
		</TABLE>


</cfoutput>

</div>

</body>
</html>
