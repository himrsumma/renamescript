#script om snel opdrachtbestanden uit submappen te filteren van teams en te hernoemen naar de student die het gemaakt heeft
#HIMR. 
$path = "geefpadop"

function Convert-Umlaut
{
  param
  (
    [Parameter(Mandatory)]
    $Text
  )
    
  $output = $Text.Replace('ö','o').Replace('ä','a').Replace('ü','u').Replace('ß','ss').Replace('Ö','O').Replace('Ü','U').Replace('Ä','A').Replace('Ç','C').Replace('ç',' c')
  $isCapitalLetter = $Text -ceq $Text.toUpper()
  if ($isCapitalLetter) 
  { 
    $output = $output.toUpper() 
  }
  $output
}


$s = Get-ChildItem -Path $path -Include *troubleshooting*,*.docx -Recurse

$p = Get-ChildItem $s -Include *.docx
$u = $p | Where-Object {$_ -notlike "*Virtualisatie*"}
$cnt = 0
foreach ($i in $u){
    $cnt = $cnt + 1
    write-host $cnt
    $str = $i.Name
    $filepath = $i.FullName
    $a = $filepath.Split("\")
    #write-host $a[5]
    $b = $a[5].Replace(' ','')
    # write-host $b
    $c = $b.Replace(',','')
    #write-host $c
    $d = Convert-Umlaut $c
    
    $z = $cnt.ToString()
    $oldname = $str
    $newname = $z + $d + "-pj4.docx"
    write-host $newname
    rename-item $i -NewName $newname
 }



