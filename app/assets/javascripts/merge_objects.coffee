window.mergeObjects = (target, source) ->
  item = undefined
  tItem = undefined
  o = undefined
  idx = undefined

  if typeof source == 'undefined'
    return source
  else if typeof target == 'undefined'
    return target
  for prop of source
    item = source[prop]
    if typeof item == 'object' and item != null
      if $.isArray(item) and item.length
        if typeof item[0] != 'object'
          tItem = target[prop]
          if !tItem
            target[prop] = item
          else
            o = {}
            i = 0
            iLen = tItem.length
            while i < iLen
              o[tItem[i]] = true
              i++
            j = 0
            jLen = item.length
            while j < jLen
              if !(item[j] of o)
                tItem.push item[j]
              j++
        else
          idx = {}
          tItem = target[prop]
          k = 0
          kLen = tItem.length
          while k < kLen
            idx[tItem[k].id] = tItem[k]
            k++
          l = 0
          ll = item.length
          while l < ll
            if !(item[l].id of idx)
              tItem.push item[l]
            else
              mergeObjects idx[item[l].id], item[l]
            l++
      else
        mergeObjects target[prop], item
    else
      target[prop] = item
  target
