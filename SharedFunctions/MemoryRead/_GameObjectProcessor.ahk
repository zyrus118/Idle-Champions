; A class to process game objects after they are constructed:
; 1. Populates the children dictionary. (currently only for collections)
; TODO add name and full name members to all game objects

class _GameObjectProcessor
{
    ProcessGameObject(gameObject)
    {
        for k, v in gameObject
        {
            ; avoid recursion
            if (InStr(k, "sh_"))
            {
                continue
            }
            ; Process down the chain
            if (v.__Class == "GameObjectStructure")
            {
                _GameObjectProcessor.ProcessGameObject(v)
            }

            ; Only create a dictionary of children for collected types
            if (v.sh_isCollection)
            {
                for childName, childObject in v
                {
                    if (childObject.__Class == "GameObjectStructure")
                    {
                        v.sh_children[childName] := childObject ; 'children' == an associative array defined previously.
                    }
                }
            }
        }
    }
}