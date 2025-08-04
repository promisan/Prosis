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
<table cellpadding="0" cellspacing="0" border="0">
	<!--- ----------------FIRST WIDGET BLOCK---------------- --->
	<tr>
		<td width="100%">		
			<table 
			cellpadding="0" 
			cellspacing="0" 
			border="0" 
			width="300px" 
			align="center">
				<tr>					
					<td>
						<table cellpadding="0" cellspacing="0" border="0" width="100%" align="center" id="wid" name="wid" class="widgetselected" onclick="ReverseDisplayx('sub1x'); widselect(this); ">
							<tr>
								<td height="2px"></td>
							</tr>
							
							<tr>
								<td height="34px" align="center" valign="middle">
									<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%" style="background-image:url('Extended/Images/widget/report_a_security_issue.png'); background-repeat:no-repeat; background-position:center center">
										<tr>
											<td align="center" valign="middle" class="widgethighlight" id="tis" name="tis" onclick="widclass(this);">
												System operational scope
											</td>
										</tr>
									</table>
								</td>
							</tr>
							
							<tr>
								<td height="2px"></td>
							</tr>
							
							<tr>
								<td>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>			
		</td>
	</tr>
	
	<tr>
		<td valign="top" width="100%" height="1px">
			<table cellpadding="0" cellspacing="0" border="0" width="300px" align="center" id="sub1x" name="sub1x" style="display:block;">
				<tr>
					<td width="1px"></td>
					<td align="left"
					style="padding-top:4px; padding-left:25px">			
						<font color="#001932" face="calibri" size="2">
							Lorem ipsum dolor sit amet, nec mauris felis, velit scelerisque volutpat in consectetuer consectetuer quis. Laoreet suscipit exercitation. Ut leo velit erat curabitur mauris nullam.
						</font>
					</td>
					<td width="1px"></td>
				</tr>
				<tr><td colspan="3" height="8px"></td></tr>
			</table>
		</td>
	</tr>
	
	<!--- ----------------SECOND WIDGET BLOCK---------------- --->
	<tr>
		<td width="100%">
			<table 
			cellpadding="0" 
			cellspacing="0" 
			border="0" 
			width="300px" 
			align="center">
				<tr>
					<td>
						<table cellpadding="0" cellspacing="0" border="0" width="100%" align="center" id="wid" name="wid" class="widgetregular" onclick="ReverseDisplayx('sub2x'); widselect(this);">
							<tr>
								<td height="2px"></td>
							</tr>
							
							<tr>
								<td height="34px" align="center" valign="middle">
									<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%" style="background-image:url('Extended/Images/widget/what_can_i_do.png'); background-repeat:no-repeat; background-position:center center">
										<tr>
											<td align="center" valign="middle" class="widgetnormal" id="tis" name="tis" onclick="widclass(this);">
												Need more information?
											</td>
										</tr>
									</table>
								</td>
							</tr>
							
							<tr>
								<td height="2px"></td>
							</tr>
							
							<tr>
								<td>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	
	<tr>
		<td valign="top" width="100%" height="1px">
			<table cellpadding="0" cellspacing="0" border="0" width="300px" align="center" id="sub2x" name="sub2x" style="display:none;">				
				<tr>
					<td width="1px"></td>
					<td align="left" 
					style="padding-top:4px; padding-left:25px">
						<font color="#001932" face="calibri" size="2">
							&nbsp;<img src="Extended/Images/widget/link_icon.gif" alt="" border="0">&nbsp;Lorem ipsum dolor sit amet, nec mauris felis
							<br>
							<cfoutput>
							<img src="#SESSION.root#/Images/Bullet.png" alt="" border="0" align="absmiddle">&nbsp;sit amet, nec mauris felis
							<br>
							<img src="#SESSION.root#/Images/Bullet.png" alt="" border="0" align="absmiddle">&nbsp;dolor sit amet, nec mauris felis
							</cfoutput>
						</font>
					</td>
					<td width="1px"></td>
				</tr>
				<!---
				<tr>
					<td colspan="3"><img src="Images/spacer.png" alt="" width="300px" height="1px" border="0"></td>
				</tr>
				--->
				<tr><td colspan="3" height="8px"></td></tr>
			</table>
		</td>
	</tr>
	
	<!--- ----------------THIRD WIDGET BLOCK---------------- --->
	<tr>
		<td>
			<table 
			cellpadding="0" 
			cellspacing="0" 
			border="0" 
			width="300px" 
			align="center">
				<tr>
					<td>
						<table cellpadding="0" cellspacing="0" border="0" width="100%" align="center" id="wid" name="wid" class="widgetregular" onclick="ReverseDisplayx('sub3x'); widselect(this);">
							<tr>
								<td height="2px"></td>
							</tr>
							
							<tr>
								<td height="34px" align="center" valign="middle">
									<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%" style="background-image:url('Extended/Images/widget/current_threat_levels.png'); background-repeat:no-repeat; background-position:center center">
										<tr>
											<td align="center" valign="middle" class="widgetnormal" id="tis" name="tis" onclick="widclass(this);">
												Important alerts
											</td>
										</tr>
									</table>
								</td>
							</tr>
							
							<tr>
								<td height="2px"></td>
							</tr>
							
							<tr>
								<td>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	
	<tr>
		<td valign="top" width="100%" height="1px">
			<table cellpadding="0" cellspacing="0" border="0" width="300px" align="center" id="sub3x" name="sub3x" style="display:none">
				<tr>
					<td width="1px" style="background-image:url('Images/widget/gradient_border.png'); background-repeat:no-repeat; background-position:top right"></td>
					<td align="left" 
					style="padding-top:4px; padding-left:25px">
						<font color="#001932" face="calibri" size="2">
						<cfoutput>
							<img src="#SESSION.root#/Images/Bullet.png" alt="" border="0" align="absmiddle">&nbsp;Lorem ipsum dolor sit amet, nec mauris										
							<br>
							<img src="#SESSION.root#/Images/Bullet.png" alt="" border="0" align="absmiddle">&nbsp;dolor sit amet, nec mauris
							<br>
							<img src="#SESSION.root#/Images/Bullet.png" alt="" border="0" align="absmiddle">&nbsp;ipsum dolor sit amet, nec mauris
						</cfoutput>
						</font>
					</td>
					<td width="1px"></td>
				</tr>
				<!---
				<tr>
					<td colspan="3"><img src="Images/spacer.png" alt="" width="300px" height="1px" border="0"></td>
				</tr>
				--->
				<tr><td colspan="3" height="8px"></td></tr>
			</table>
		</td>
	</tr>
</table>