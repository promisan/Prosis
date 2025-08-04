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


<script language="javascript">
	function showFields(){
	
		var list = document.getElementById('TriggerGroup');
		var type = list[list.selectedIndex].value;
	
		if (type == "Process") opposite = "Bucket"
		else opposite = "Process"
		
		var r = document.getElementById('myTable').rows;
		for (i=0; i<r.length; i++)
		{
			row = r[i];
			if (row.className==("r_"+type))
				row.style.display="";
			else if (row.className==("r_"+opposite))
				row.style.display="none";
		}
		
		// if (type == "Process")
		//	window.resizeTo(600,470);
		// else
		//	window.resizeTo(600,360);
			
	}
	
	function validateTemplate(){
		path = document.getElementById('ValidationPath').value;
		template = document.getElementById('ValidationTemplate').value;
		ColdFusion.navigate('validateTemplate.cfm?template='+path+template,'templateValidation');
	}
	
</script>