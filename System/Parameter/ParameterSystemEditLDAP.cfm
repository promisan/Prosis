

<cfparam name="URL.LDAPServer" default="">

<cfquery name="GetLDAP" 	
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT *
	FROM   ParameterLDAP 

</cfquery>


<!-- <FORM> -->

<table width="100%" align="center">

	<tr>
		<td width="100%"><font face="Calibri" size="3"><b>LDAP Server</b></font></td>
	</tr>

	<tr><td class="linedotted"></td></tr>

	<tr>
		<td style="padding-top:15px;padding-bottom:15px;">
			<table width="90%" align="center">
				<tr>
					<td> Server </td>
					<td> Port </td>
					<td> Domain </td>
					<td> Root </td>
					<td> Filter </td>
					<td> Operational </td>
					<td> <a href="javascript:addLDAP()"> <font color="0080FF">[Add]</font></a></td>
				</tr>
				
				<tr>
					<td class="linedotted" colspan="7"></td>
				</tr>

				<cfoutput query="GetLDAP">
				
					<cfif URL.LDAPServer eq LDAPServer>

					<tr>
						<td colspan="7">

							<table>
							<tr>
								<td> 
									<input type="text" name="LDAPServer" id="LDAPServer" value="#LDAPServer#">
								</td>
								<td>
						      	 	<input type="text" name="LDAPServerRoot" id="LDAPServerRoot" value="#LDAPServerPort#">
								</td>
							  	<td>
						      		<input type="text" name="LDAPServerDomain" id="LDAPServerDomain" value="#LDAPServerDomain#">
								</td>							  	<td>
						      		<input type="text" name="LDAPRoot" id="LDAPRoot" value="#LDAPRoot#">
							  	</td>
							  	<td>
						          <input type="text" name="LDAPFilter" id="LDAPFilter" value="#LDAPFilter#">
							  	</td>
							   <td>
						      		<cfif Operational eq 1>Yes<cfelse>No</cfif>
							   </td>
							   <td>
							   		Update
							   </td>
							</tr>
							</table>

						</td>
					</tr>
					<cfelse>
					
						<tr>
							<td> 
								#LDAPServer#
							</td>
							<td>
					      	 	#LDAPServerPort#
							</td>
						  	<td>
					      		#LDAPServerDomain#
							</td>
						  	<td>
					      		#LDAPRoot#
						  	</td>
						  	<td>
					          #LDAPFilter#
						  	</td>
						   <td>
					      		<cfif Operational eq 1>Yes<cfelse>No</cfif>
						   </td>
						   <td>
						   		<table>
									<tr>
										<td> <cf_img icon="edit" onclick="editLDAP('#LDAPServer#')"> </td>
										<td style="padding-left:10px;"> <cf_img icon="delete" onclick="deleteLDAP('#LDAPServer#')"> </td>
									</tr>
								</table>
						   </td>
						</tr>
					</cfif>
					
				</cfoutput>
				
			</table>
		</td>
	</tr>		

</table>

<!-- </FORM> -->