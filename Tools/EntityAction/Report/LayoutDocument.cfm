
<cfparam name="Attributes.Class" 	        default="Memo">
<cfparam name="Attributes.DocumentDate" 	default="">
<cfparam name="Attributes.Reference"        default="">
<cfparam name="Attributes.To"	            default="">
<cfparam name="Attributes.From" 	        default="">
<cfparam name="Attributes.Subject"          default="">

<cfparam name="Attributes.Logo" 		    default="">
<cfparam name="Attributes.TitleLine1"       default="">
<cfparam name="Attributes.TitleLine2"       default="">
<cfparam name="Attributes.TitleLine3"       default="">
<cfparam name="Attributes.TitleLine4"       default="">
<cfparam name="Attributes.TitleLine5"       default="">

<cfparam name="Attributes.SignatureTitle"   default="">
<cfparam name="Attributes.SignatureLine1"   default="">
<cfparam name="Attributes.SignatureLine2"   default="">
<cfparam name="Attributes.SignatureLine3"   default="">
<cfparam name="Attributes.SignatureLine4"   default="">

<cfparam name="Attributes.SectionLine"      default="No">

<cfparam name="Attributes.Closign"          default="">
<cfparam name="Attributes.SignedBy"         default="">
<cfparam name="Attributes.SignatureLabel"   default="">
<cfparam name="Attributes.AdditionalDocs"   default="">

<cfif thisTag.ExecutionMode is 'start'>
	
	<html>
	
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>				
		<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#</cfoutput>/tools/entityAction/Report/LayoutStyleSheet.css">					
	</head>
		
	<body>

		<table width="99%" id="tmain">
						
		<cfif Attributes.TitleLine1 neq "" or
		  Attributes.Logo neq "" or
		  Attributes.TitleLine2 neq "" or 
		  Attributes.TitleLine3 neq "" or
		  Attributes.TitleLine4 neq "" or
		  Attributes.TitleLine5 neq "">		
		  
		  <tr align="center" valign="top">
				<td colspan="3" height="60" width="100%" style="padding-top:20px">
				
					<table width="100%">

						<tr>
						    <cfif Attributes.TitleLine1 neq "">
							
							<td valign="bottom" align="right" width="45%" class="serif">
								<cfoutput>#Attributes.TitleLine1#</cfoutput>
							</td>
							<td align="center" width="10%">
								<cfoutput>#Attributes.Logo#</cfoutput>
							</td>
							<td valign="bottom" align="left" width="45%" class="serif">
								<cfoutput>#Attributes.TitleLine2#</cfoutput>
							
							</td>
							
							<cfelse>	
													
							<td align="center" style="padding-left:30px;width:80px">
								<cfoutput>#Attributes.Logo#</cfoutput>
							</td>
							
							<td valign="bottom" align="left" style="padding-left:10px;width:95%">
							 
							    <table>
								<tr><td class="serif"><cfoutput>#Attributes.TitleLine2#</cfoutput></td></tr>
								<cfif attributes.TitleLine3 neq "">
								<tr><td style="font-size:16px"><cfoutput>#Attributes.TitleLine3#</cfoutput></td></tr>
								</cfif>
								</table>							   
														
							</td>
							
							</cfif>
							
						</tr>
						
						<cfswitch expression="#Attributes.Class#">
						
						<cfcase value="Memo">
							<tr>
							    <cfif Attributes.TitleLine3 neq "">
								<td align="right" width="45%" class="serif_small">
								<cfoutput>#Attributes.TitleLine3#</cfoutput>								
								</td>
								</cfif>
								<td align="center" width="10%"></td>
								<td align="left" width="45%" class="serif_small">
								<cfoutput>#Attributes.TitleLine4#</cfoutput>
								</td>
							</tr>				
						</cfcase>
						
						<cfcase value="Letter">
						
							<cfif Attributes.TitleLine3 neq "">
							<tr>
								<td colspan="3" align="center" class="serif_small">
								<cfoutput>#Attributes.TitleLine3#</cfoutput>								
								</td>
							</tr>	
							</cfif>
							<cfif Attributes.TitleLine4 neq "">
							<tr>
								<td colspan="3" align="center" class="serif_small">
								<cfoutput>#Attributes.TitleLine4#</cfoutput>								
								</td>
							</tr>		
							</cfif>					
							<cfif Attributes.TitleLine5 neq "">
							<tr>
								<td colspan="3" align="center" class="serif_small">
								<cfoutput>#Attributes.TitleLine5#</cfoutput>
								</td>
							</tr>
							</cfif>														
						</cfcase>
						
						<cfcase value="Note">
							<tr>
								<td colspan="3" align="center">
								<cfoutput>#Attributes.TitleLine3#</cfoutput>								
								</td>
							</tr>	
							<tr>
								<td colspan="3" align="center">
								<cfoutput>#Attributes.TitleLine4#</cfoutput>
								</td>
							</tr>
							<cfif Attributes.TitleLine5 neq "">
							<tr>
								<td colspan="3" align="center">
								<cfoutput>#Attributes.TitleLine5#</cfoutput>
								</td>
							</tr>
							</cfif>														
						</cfcase>		
																		
						</cfswitch>						

					</table>
				</td>
		  </tr>
		 </cfif>		
		 
						
			<cfswitch expression="#Attributes.Class#">
		
				<cfcase value="Memo">
				 <tr>			
					<td width="5%"></td>
				    <td width="80%" class="serif_small">
						<cfinclude template="Layouts/Memo.cfm">
					</td>
				</tr>	
				</cfcase>
				<cfcase value="Letter">
				<tr>			
					<td width="5%"></td>
				    <td width="80%" class="serif_small">
						<cfinclude template="Layouts/Letter.cfm">
					</td>
				</tr>		
				</cfcase>							
		
			</cfswitch>
			
		  <tr>
		    <td width="5%"></td>
		    <td width="80%" class="serif_small">
						
			<!--- body content comes here to be loaded on the fly --->
						
<cfelse>

			<!--- end template --->

		    </td>
			<td width="5%"></td>
		  </tr>
		  
		 <tr>
			<td width="5%"></td>
			<td width="80%" class="serif_small">
			
		 <!---We should see if there is a signature block --->
		 <cfswitch expression="#Attributes.Class#">
		
			<cfcase value="Memo">
					<cfinclude template="Layouts/Signature_Memo.cfm">
			</cfcase>
			<cfcase value="Letter">
					<cfinclude template="Layouts/Signature_Letter.cfm">
			</cfcase>							
		
		</cfswitch>			
		
		<!----- we should print the botton of the page --->
		
		    </td>
			<td width="5%"></td>
		  </tr>
			
		</table>		
		
		</body>
		</html>
		
</cfif>  

