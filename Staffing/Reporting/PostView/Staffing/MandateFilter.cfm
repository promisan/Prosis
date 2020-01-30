



<cfquery name="Parameter" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Parameter
</cfquery>

<cfquery name="OccGroup" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
    FROM     OccGroup
	WHERE    OccupationalGroup IN (SELECT OccupationalGroup
	                               FROM   FunctionTitle FT
								   WHERE  FunctionNo IN (SELECT FunctionNo 
								                         FROM   Employee.dbo.Position 
														 WHERE  FunctionNo = FT.FunctionNo
													     AND    Mission = '#url.mission#')
							    )
	ORDER BY Description
</cfquery>

<cfquery name="PostClass" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_PostClass
	WHERE PostClass IN (SELECT PostClass FROM Position WHERE Mission = '#URL.Mission#')
</cfquery>

<cfquery name="PostType" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_PostType
	WHERE  PostType IN (SELECT PostType 
	                    FROM   Position 
						WHERE  Mission = '#URL.Mission#')
</cfquery>

<cfquery name="Postgrade" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   Code, Description, Category
    FROM     Ref_PostGradeParent
	WHERE    Code IN (SELECT PostgradeParent 
	                  FROM   Ref_PostGrade 
					  WHERE  PostGrade IN (SELECT PostGrade  
	                                       FROM   Position 
										   WHERE  Mission = '#URL.Mission#')
				   )
	ORDER BY Category,ViewOrder
</cfquery>


<!--- Search form --->

<cfoutput>

<form action="MandateFilterSubmit.cfm?Mission=#URL.Mission#&Mandate=#URL.Mandate#&Unit=#URL.Unit#&Tree=#URL.Tree#&Mode=<cfoutput>#Parameter.AccessMode#</cfoutput>" 
    		method="post" 
			name="positionsearch">	
    
<table width="96%" border="0" align="center" cellspacing="0" cellpadding="0" class="formpadding">
	
    <tr><td>	
       
	<table border="0" align="center" cellspacing="" cellpadding="0" bgcolor="ffffff" class="formpadding">
			
    <TR>
	
	<cfquery name="getFilter" dbtype="query">
			SELECT *
		    FROM   Filter
			WHERE  FilterField = 'Occ'
	</cfquery>	
	
	<TD>
	
		<table cellspacing="0" cellpadding="0">
		<tr>
			<td style="padding-bottom:4px" class="labelmedium"><cf_tl id="Occupational group">:</b></td>
		</tr>
		<tr>	
			<td>
			  
		    	<select name="occgroup" size="6" multiple class="regularxl" style="width:200px;height:100">
				    <cfif getFilter.recordcount eq "0">
					<option value="" selected><cf_tl id="Any"></option>
					<cfelse>
					<option value=""><cf_tl id="Any"></option>
					</cfif>
				    <cfloop query="OccGroup">
					<option value="#OccupationalGroup#" <cfif find(OccupationalGroup,  quotedValueList(getFilter.FilterValue))>selected</cfif>>
			    	#Description#
					</option>
					</cfloop>
			    </select>
			</td>		
		</tr>
		</table>
				
	</TD>
	
	<cfquery name="getFilter" dbtype="query">
			SELECT *
		    FROM   Filter
			WHERE  FilterField = 'Cat'
	</cfquery>	
	
	<td valign="top">
	
		<table cellspacing="0" cellpadding="0">
			<tr><td style="padding-bottom:4px" class="labelmedium">
				<cf_tl id="Category">: 
				</td>
			</tr>
		<tr>
			<TD valign="top">	
		    	<select name="Category" size="6" multiple class="regularxl" style="width:200px;height:100">
				<cfif getFilter.recordcount eq "0">
					<option value="" selected><cf_tl id="Any"></option>
				<cfelse>
					<option value=""><cf_tl id="Any"></option>
				</cfif>
			    <cfloop query="PostGrade">
				<option value="#Code#" <cfif find(Code,  quotedValueList(getFilter.FilterValue))>selected</cfif>>
		    		#Description#
				</option>
				</cfloop>
			    </select>		
			</td>		
		</tr>
		</table>
				
	</TD>
	
	<cfquery name="getFilter" dbtype="query">
			SELECT *
		    FROM   Filter
			WHERE  FilterField = 'Cls'
	</cfquery>	
	
	<td valign="top">
	
		<table cellspacing="0" cellpadding="0">
		    <tr><td style="padding-bottom:4px" class="labelmedium">
			<cf_tl id="Post Class">:</td>
			</tr>
			<tr>
				<TD valign="top">
			    <select name="Class" size="6" multiple class="regularxl" style="width:200px;height:100">
				<cfif getFilter.recordcount eq "0">
					<option value="" selected><cf_tl id="Any"></option>
				<cfelse>
					<option value=""><cf_tl id="Any"></option>
				</cfif>
				<cfloop query="PostClass">
					<option value="#PostClass#" <cfif find(PostClass,  quotedValueList(getFilter.FilterValue))>selected</cfif>>
		    			#Description#
					</option>
				</cfloop>
	    		</select>				
				</TD>
			</tr>
		</table>	
		
	</td>	
	
	<cfquery name="getFilter" dbtype="query">
			SELECT *
		    FROM   Filter
			WHERE  FilterField = 'Pte'
	</cfquery>	
	
	<td valign="top">
	
		<table cellspacing="0" cellpadding="0">
		    <tr><td style="padding-bottom:4px" class="labelmedium">
			<cf_tl id="Post Type">:</td>
			</tr>
			<tr>
				<TD valign="top">
				
			    	<select name="PostType" size="6" multiple class="regularxl" style="width:200px;height:100">
					<cfif getFilter.recordcount eq "0">
						<option value="" selected><cf_tl id="Any"></option>
					<cfelse>
						<option value=""><cf_tl id="Any"></option>
					</cfif>
				    <cfloop query="PostType">
					<option value="#PostType#" <cfif find(PostType,  quotedValueList(getFilter.FilterValue))>selected</cfif>>
		    			#Description#
					</option>
					</cfloop>
	    			</select>		
						
				</TD>
			</tr>
		</table>	
		
	</td>	
	
	<cfquery name="getFilter" dbtype="query">
			SELECT *
		    FROM   Filter
			WHERE  FilterField = 'Aut'
	</cfquery>	
	
	<td valign="top">
	
		<table cellspacing="0" cellpadding="0">
		    <tr><td style="padding-bottom:4px" class="labelmedium">
			<cf_tl id="Status">:</td>
			</tr>
			<tr>
				<TD valign="top">
				    <select name="Authorised" size="6" multiple class="regularxl" style="width:200px;height:100">
					<cfif getFilter.recordcount eq "0">
						<option value="" selected><cf_tl id="Any"></option>
					<cfelse>
						<option value=""><cf_tl id="Any"></option>
					</cfif>							    	
					<option value="1" <cfif find('1', quotedValueList(getFilter.FilterValue))>selected</cfif>><cf_tl id="Authorised"></option>									
					<option value="0" <cfif find('0', quotedValueList(getFilter.FilterValue))>selected</cfif>><cf_tl id="Not Authorised"></option>	
					</select>	
						
				</TD>
			</tr>
						
		</table>	
		
	</td>	
				
	</TR>	
	
		
	<tr class="line" style="border-top:1px solid silver"><td colspan="5" align="center" height="45" bgcolor="ffffff">
	<cf_tl id="Apply Filter" var="1">
	<input type="submit" name="Submit" value="<cfoutput>#lt_text#</cfoutput>" style="width:140;height:30" class="button10g">
	</td></tr>
	
	</TABLE>
	</td>
	</tr>
	
	</table>
	
	</FORM>
	

</cfoutput>	


		


