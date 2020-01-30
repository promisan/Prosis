
<cfparam name="Attributes.Context"   default="">
<cfparam name="Attributes.Id"        default="">
<cfparam name="Attributes.Declaimer" default="">

<cfquery name="qObject" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT   O.* , R.EntityDescription, R.DocumentPathName
	 FROM     OrganizationObject O, Ref_Entity R
	 WHERE    ObjectId = '#Attributes.ObjectId#'
	 AND      O.EntityCode = R.EntityCode
	 AND     O.Operational  = 1
</cfquery>

<cfoutput>

	<table width="100%">
			   
		<tr><td height="10"></td></tr>	
		
		<cfoutput>
		<tr>
		<td colspan="2" align="center">
		<img src="#session.root#/images/Logos/System/Support.png" height="58" width="58" alt="" border="0">
		 </td>
		</tr>
		</cfoutput>
		
		<tr>
		<td colspan="2" align="center">
		 <font face="Verdana" size="2" color="808080">
			 This #attributes.context# is related to :<br><br> <font face="Verdana" size="4" color="black">#qObject.ObjectReference# raised by #qObject.ObjectReference2#</font>.
		 </font>
		 </td>
		</tr>
		
		<tr><td height="10"></td></tr>
		
		<tr>			
			<td class="description" align="center">
			<font face="Verdana" size="2" color="808080">
			<a href="#SESSION.root#/ActionView.cfm?id=#qObject.Objectid#"><font color="0080FF">Press here to open it</a></b>
			</font>
			</td>
		</tr>		
		
	</table>

</cfoutput>

		