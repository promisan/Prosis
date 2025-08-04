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

<cfparam name="URL.ID2" default="SAT">

<!--- Search form --->
<cfform method="POST" name="filterform" onsubmit="return false">

<table width="100%" border="0" class="formspacing" align="left">
<tr>

<cf_verifyOperational 
         module="Procurement" 
		 Warning="No">
		 
<cfif operational eq "1">	 

<cfquery name="Vendor" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT OrgUnit, OrgUnitName
	FROM  Organization
	WHERE OrgUnit IN (SELECT OrgUnitVendor 
	                  FROM Purchase.dbo.Purchase 
	                  WHERE Mission='#URL.ID2#') 
    ORDER BY OrgUnitName
</cfquery>

</cfif>	

<cfif url.id eq "TOD">
	<cfset st = dateformat(now(), CLIENT.DateFormatShow)>
<cfelse>
	<cfset st = "">	
</cfif>


<cfif url.id eq "REC">
	<cfset rc = dateformat(now(), CLIENT.DateFormatShow)>
<cfelse>
	<cfset rc = "">	
</cfif>

<td>	

<table width="99%" class="formpadding" align="center">

    <TR>
	<TD style="padding-left:2px" class="labelmedium"><cf_tl id="Received">:</TD>
	<td colspan="1">	
		<table cellspacing="0" cellpadding="0">
			<tr class="fixlengthlist"><td>			
			 <cf_intelliCalendarDate9
				FieldName="datestart" 
				Default="#st#"
				class="regularxl"
				AllowBlank="True">	
			</td>
			<td>-</td>
			<td>			
			<cf_intelliCalendarDate9
				FieldName="dateend" 
				Default="#st#"
				class="regularxl"
				AllowBlank="True">					
			</td>
			</tr>
		</table>	
		
	</TD>
	
	<cfquery name="Category" 
		   datasource="appsMaterials" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			SELECT *
			FROM Ref_Category
			WHERE Category IN (SELECT Category 
		                       FROM Item
					           WHERE ItemClass = 'Asset')
			<!--- has been used --->		   
			AND   Category IN (SELECT I.Category 
			                   FROM   AssetItem A, Item I 
							   WHERE  A.ItemNo = I.ItemNo 
							   AND    A.Mission = '#url.id2#')	
							   
			AND Category IN (SELECT Category 
			                 FROM   Item 
						     WHERE  ItemNo IN (SELECT ItemNo FROM   userquery.dbo.#SESSION.acc#AssetBase#url.id#)
				)				  				   
			
			<cfif getAdministrator(url.id2) eq "1">
	
				<!--- no filtering --->
				
			<cfelse>
				
			  	AND  Category IN (SELECT DISTINCT ClassParameter 
								  FROM   Organization.dbo.OrganizationAuthorization 
								  WHERE  UserAccount = '#SESSION.acc#' 
								  AND    Role IN ('AssetManager', 'AssetHolder'))
				
			</cfif>		
    </cfquery>	 
	
	<td class="labelmedium"><cf_tl id="Category">:</td>
	   <td>
	   
	   <select name="Category" id="Category" class="regularxl" size="1" style="width:200px;font:10px">
		    <option value="" selected>All</option>
		    <cfoutput query="Category">
			<option value="#Category#">#Description#</option>
			</cfoutput>
	    </select>  
	   
	   
	   </td>
	
	
	</tr>
	
	
	<tr>
	   
	   <TD style="padding-left:2px" class="labelmedium"><cf_tl id="Recorded">:</TD>
	<td>	
		<table cellspacing="0" cellpadding="0">
			<tr class="fixlengthlist"><td>			
			 <cf_intelliCalendarDate9
				FieldName="createdstart" 
				Default="#rc#"
				class="regularxl"
				AllowBlank="True">	
			</td>
			<td>-</td>
			<td>			
			<cf_intelliCalendarDate9
				FieldName="createdend" 
				Default="#rc#"
				class="regularxl"
				AllowBlank="True">					
			</td>
			</tr>
		</table>	
		
	</TD>
	   
	   <td class="fixlength labelmedium"><cf_tl id="Current"><cf_tl id="Location">:</td>
	   
	   <td>
	   
	   <cfquery name="LocationList" 
		   datasource="appsMaterials" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			SELECT *
			FROM   Location
			WHERE  Location IN (SELECT Location FROM userquery.dbo.#SESSION.acc#AssetBase#url.id#)
        </cfquery>	 
		
		  
	   <select name="Location" id="Location" class="regularxl" size="1" style="font:10px;width:200px">
		    <option value="" selected>All</option>
		    <cfoutput query="LocationList">
			<option value="#Location#">#LocationCode# #LocationName#</option>
			</cfoutput>
	    </select>  
	   
	   </td>
	
	</tr>
	
	<!---
		
	<TR>
		<TD class="labelmedium"><cf_tl id="Barcode">:</TD>
		<td align="left" valign="top">
		 <input type="text" name="AssetBarcode" id="AssetBarcode" class="regular" size="20" maxlength="20">
		</td>	
			
		<TD class="labelmedium"><cf_tl id="DecalNo">:</TD>
				
		<td align="left" valign="top">
		  <input type="text" name="AssetDecalNo" id="AssetDecalNo" class="regular" size="30" maxlength="30">
		</TD>
	</tr>
	
	--->
			
	<cfquery name="Make" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
		FROM  Ref_Make	
		WHERE Code IN (SELECT Make 
		               FROM AssetItem 
					   WHERE Mission = '#URL.ID2#')
		AND Code IN (SELECT Make  FROM userquery.dbo.#SESSION.acc#AssetBase#url.id#)				  			   
		ORDER BY Description
	</cfquery>
		
	<TR class="fixlengthlist">
	<TD class="labelmedium"><cf_tl id="Make">:</TD>
			
		<td align="left" valign="top">
		<select name="Make" id="Make" class="regularxl" size="1" style="width:200px;font:10px">
		    <option value="" selected>All</option>
		    <cfoutput query="Make">
			<option value="#Code#">#Description#</option>
			</cfoutput>
	    </select>
		</td>	
		
	<cfif operational eq "1">	
		
	<TD class="labelmedium"><cf_tl id="Vendor">:</TD>
			
		<td align="left" valign="top">
		    <select name="orgunitvendor" class="regularxl" id="orgunitvendor" size="1" style="width:200px;font:10px">
			<option value="" selected><cf_tl id="All"></option>
		    <cfoutput query="Vendor">
				<option value="#OrgUnit#">#OrgUnitName#</option>
			</cfoutput>
		    </select>
		</td>	
		
	</cfif>	
	
	</tr>
				
	<TR class="fixlengthlist">
	
		<td class="labelmedium" colspan="1"><cf_tl id="Descr.">/<cf_tl id="model">:</td>
		<td colspan="1">	
		<input type="text" name="assetitem" id="assetitem" class="regularxl" value="" size="30" maxlength="40">
		</td>
	
		<td class="labelmedium" colspan="1"><cf_tl id="Employee">:</td>
		<td colspan="1">	
		
		<cfquery name="Person" 
		datasource="appsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT * 
			FROM  Person
			WHERE PersonNo IN (SELECT PersonNo 
			                    FROM userquery.dbo.#SESSION.acc#AssetBase#url.id#)	
			ORDER By LastName,FirstName								  			   
		</cfquery>
		
		<select name="PersonNo" id="PersonNo" size="1" class="regularxl">
		    <option value="" selected>All</option>
		    <cfoutput query="Person">
			<option value="#PersonNo#">#FirstName# #LastName#</option>
			</cfoutput>
	    </select>
		
		</td>
		
	</tr>
	
	<TR class="fixlengthlist">
				
		<TD class="labelmedium"><cf_tl id="Barcode">/<cf_tl id="SerialNo">:</TD>
				
		<td align="left" valign="top">
		  <input type="text" name="SerialNo" id="SerialNo" class="regularxl" size="30" maxlength="40">
		</TD>
			
		<td class="labelmedium" colspan="1"><cf_tl id="Disposed">:</td>
		<td colspan="1" class="labelmedium" style="padding-top:2px">	
		<input type="radio" name="Operational" id="Operational" value="1" checked><cf_tl id="No">
		<input type="radio" name="Operational" id="Operational" value="0"><cf_tl id="Yes">
		</td>
		
	</tr>
	
			
	<cfif url.id eq "ITM">	
	
		<cfquery name="Topic" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT  R.*
		   FROM   ItemTopic T, Ref_Topic R
		  WHERE   ItemNo = '#URL.ID1#'
		    AND   R.Operational = 1
			AND   R.Code = T.Topic
		</cfquery>
			
		<cfif Topic.recordcount gt "0">
			
		<cfoutput query="topic">
		<tr>
			<td class="labelmedium">#Description#:</td>
			<td colspan="4">
			
			<cfquery name="List" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  SELECT  *
			     FROM  Ref_TopicList R
				 WHERE Code = '#Code#'
			</cfquery>
					
			<select name="ListCode_#Code#" id="ListCode_#Code#" class="regularxl" required="No" style="font:10px">
			    <option value="""">---select---</option>
				<cfloop query="List">
				<option value="#ListCode#">#ListValue#</option>
				</cfloop>
			</select>
			</td>
		</tr>
		</cfoutput>
		
		</cfif>	
	
	</cfif>
	<!--- Field: Pur_head.AmountUSD=FLOAT;8;FALSE --->	
	
</TABLE>
</td></tr>

<cfoutput>
	<tr><td height="1" class="line"></td></tr>
	<tr>
	<td align="center" height="35">
	<input type="reset"  class="button10g" style="width:140;height:23" value="Reset">
	<input type   = "submit" 
	       name   = "Submit" 
		   Id     = "Submit"
		   value  = "Filter" 
		   class  = "button10g" style="width:140;height:23" 
		   onclick= "listfilter('#URL.ID#','#URL.ID1#','#URL.ID2#')">

	</td>
	</tr>
</cfoutput>

</table>

</cfform>

<cfset ajaxOnLoad("doCalendar")>


