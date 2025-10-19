-- vanilla-wow lua does not predefine the _G symbol globally like standard lua does   hence we polyfill it

_G = _G or assert(getfenv)(0) -- vanilla wow lua does have assert on the global scope so we can use it here

assert(_G)
