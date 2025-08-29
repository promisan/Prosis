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
<cfparam name="url.box" default="mybox">
<cfparam name="box" default="#url.box#">

<cfparam name="session.listingdata['#box#']['explore']" default="0">

<cfset explore    = session.listingdata[box]['explore']>
<cfset sorting    = session.listingdata[box]['sqlsorting']>
<cfset listlay    = session.listingdata[box]['listlayout']>

<cfoutput>

<!--- 0. explore enabled / disabled --->

<cfif explore eq "1">
	
	<script>		
		  try {		
	    $('###box#_column1').addClass('regular').removeClass('hide')	
		$('###box#_groupcell1').addClass('hide').removeClass('regular')		
		$('###box#_groupcell1formula').addClass('hide').removeClass('regular')		
		} catch(e) {}
	</script>	
	
	<!--- 1. control the visibility of the check box to sort the grouping or not --->
	
	<cfset sortgroup = "1">
	
	<cfloop array="#listlay#" index="current">
	
	       <cfparam name="current.aggregate" default="">
		<cfif current.aggregate eq "sum">	
		
			<cfif findNoCase(current.field,sorting)>
			 	<cfset sortgroup = "0">																					
			</cfif>
		
		</cfif>
									
	</cfloop>
		
	<cfif sortgroup eq "0">
		<script>
			$('###box#_groupsort').addClass('hide').removeClass('regular')		
		</script>
	<cfelse>
	    <script>
			$('###box#_groupsort').addClass('regular').removeClass('hide')		
		</script>
	</cfif>
		
	<!--- 2. control the visibility of the summary cell which is not relevant --->
	
	<cfparam name="session.listingdata[url.box]['colnfield']" default="">
	
	<cfset cell1 = session.listingdata[url.box]['colnfield']>
	
	<cfif cell1 eq "">
	
		<script>	   
			$('###box#_groupcell1').addClass('hide').removeClass('regular')		
			$('###box#_groupcell1formula').addClass('hide').removeClass('regular')		
		</script>
	
	<cfelse>
	
	    <script>
			$('###box#_groupcell1').addClass('regular').removeClass('hide')		
			$('###box#_groupcell1formula').addClass('regular').removeClass('hide')
		</script>
	
	</cfif>
		
	<!--- 3. control the visibility of the summary cell which is not relevant --->
	
	<cfparam name="session.listingdata[url.box]['datacell1']" default="">
	
	<cfset formula1 = session.listingdata[url.box]['datacell1']>
	
	<cfif formula1 eq "Total">
	
		<script>			
			$('###box#_groupcell1formula').addClass('hide').removeClass('regular')		
		</script>
	
	<cfelse>
	
	    <script>		
			$('###box#_groupcell1formula').addClass('regular').removeClass('hide')
		</script>
	
	</cfif>
			
<cfelse>

    <script>	
	    try {	
	    $('###box#_column1').addClass('hide').removeClass('regular')		 
		$('###box#_groupcell1').addClass('hide').removeClass('regular')		
		$('###box#_groupcell1formula').addClass('hide').removeClass('regular')
		} catch(e) {}
	</script>

</cfif>	

</cfoutput>

