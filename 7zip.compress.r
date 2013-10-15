
# Compress log files to 7zip files.

# This is not a successful R script.
# I wasn't able to get the R script to work.
# Copy 7z.exe to the results folder in which you plan to do compression.
# open a cmd window and move the appropriate results directory
# command:
# 7z.exe a gulo.log.files.7z *.log -r -mmt

# command <- 'H:\\HexSim\\Workspaces\\wolverine_v1\\Results\\gulo.023.a2.ccsm3\\gulo.023.a2.ccsm3-[1]\\>f:\\pnwccva_data2\\7za920\\7za.exe a -t7z H:\\HexSim\\Workspaces\\wolverine_v1\\Results\\gulo.023.a2.ccsm3\\gulo.023.a2.ccsm3-[1]\\gulo.023.a2.ccsm3.log.7z *.log -mx7'

# command <- 'f:\\pnwccva_data2\\7za920\\7za.exe l H:\\HexSim\\Workspaces\\wolverine_v1\\Results\\gulo.023.a2.ccsm3\\gulo.023.a2.ccsm3-[1]\\gulo.023.a2.ccsm3.log.7z'

# command <- 'H: && cd H:\\HexSim\\Workspaces\\wolverine_v1\\Results\\gulo.017.a2.ccsm3\\ && 7z.exe a gulo.017.ccms3.log.files.7z *.log -r -mmt'

# shell(command)
# shell(shell='%windir%\\SysWoW64\\cmd.exe', command)


