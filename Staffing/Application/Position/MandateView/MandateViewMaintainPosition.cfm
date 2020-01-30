<cfoutput>

		
	<cfif DateEffective neq Mandate.DateEffective 
		    or DateExpiration neq Mandate.DateExpiration 
		    or OrgUnitOperational neq OrgUnit.OrgUnit 
			or FunctionDescription neq parentFunction>
			
			<tr bgcolor="DFFFFF">
			    <td bgcolor="white"></td>
			    <td class="labelit">
					<a title="Edit Position" 
				       href="javascript:EditPosition('#Mission#','#MandateNo#','#PositionNo#','#PositionParentId#')">
					   <font color="0080C0">#pos#. #FunctionDescription#
					</a>
				</td>
				<td></td>
				<td class="labelit">#SourcePostNumber#</td>
				<td class="labelit">#PostType#</td>
				<td align="center" class="labelit">#DateFormat(DateEffective,CLIENT.DateFormatShow)#</td>
				<td align="center" class="labelit">#DateFormat(DateExpiration,CLIENT.DateFormatShow)#</td>								
				<td></td>
			</tr>
			
	 <cfelse>
	 
			<tr class="noprint">
				
				<td></td>
				<td colspan="7" class="labelit">#SourcePostNumber#
					<a title="Edit Position" 
					   href="javascript:EditPosition('#Mission#','#MandateNo#','#PositionNo#','#PositionParentId#')">
					   <font color="b0b0b0">
				&nbsp;Position has not been changed/loaned since its inception
				</font>
				</a>
				</td>
				
			</tr>
			
    </cfif>
	
	<cfif OrgUnitOperational neq OrgUnit.OrgUnit>		
						
			<cfquery name="OrgPosition" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT *
				FROM  Organization O
				WHERE Orgunit = '#OrgUnitOperational#'
							
			</cfquery>
			
			<tr bgcolor="EAF4FF">
			    <td bgcolor="white"></td>
				<td colspan="7" class="labelit" style="padding-left:15px">Loaned to:&nbsp; #OrgPosition.OrgUnitName#</td>					 
			</tr>
		
		</cfif>		
	
	<cfif pprior gte DateEffective>
						
			<tr><td></td>
				<td colspan="7" align="center" class="labelit" bgcolor="FF0000">
				<font color="white"><b>Problem:</b> Effective date overlaps with prior position ending #DateFormat(pprior,CLIENT.DateFormatShow)#. Contact administrator
				</td>
			</tr>
										
	</cfif>		
						
	<cfset pprior = DateExpiration>	

</cfoutput>