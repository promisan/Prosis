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

<cfoutput>

	<cfparam name="url.mid" default="">
	<script>
	    <!--- stop and start the progress bar --->	
		try{
		    ColdFusion.ProgressBar.stop('pBar', true)	
		    ColdFusion.ProgressBar.start('pBar')					
		}	
		catch(ex){}
		window.report.location = "ReportSQL8.cfm?reportId=#URL.reportid#&mode=#url.mode#&category=#url.category#&userid=#url.userid#&mid=#url.mid#"	
	</script>	
	
</cfoutput>