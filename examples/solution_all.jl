using JuMP

########## fonctions auxiliers

# return le plus proche voisin de j pas encore visité
function plusProcheVoisin(j,c,visited,n)
  min_dist = n*cMax
  v = -1
  for i = 1:n
     if visited[i]==0 && c[j,i] < min_dist
        min_dist = c[j,i]
        v = i
     end
  end
  return v
end

# traiter la sequence 1:n comme un cycle
function avant(i,n)
   if i>1
      return i-1
   else
      return n
   end
end

function apres(i,n)
   if i < n
      return i+1
   else
      return 1
   end
end

# calcule la longueur d'une tour x du voyageur de commerce
function cost_sol(x,n)
   cost = 0.0
   for i = 1:n-1
      cost = cost + c[x[i],x[i+1]]
   end
   cost = cost + c[x[n],x[1]]
   return cost
end

# evalue la longueur d'une tour x si on echange x[v] et x[t]
function evaluationEchange(v,t,x,cost,n)
      if v == avant(t,n)
          new_cost = cost - c[x[avant(v,n)],x[v]] - c[x[v],x[t]] - c[x[t],x[apres(t,n)]] + c[x[avant(v,n)],x[t]] + c[x[t],x[v]] + c[x[v],x[apres(t,n)]] 
      elseif t == avant(v,n)
          new_cost = cost - c[x[avant(t,n)],x[t]] - c[x[t],x[v]] - c[x[v],x[apres(v,n)]] + c[x[avant(t,n)],x[v]] + c[x[v],x[t]] + c[x[t],x[apres(v,n)]] 
      else
         new_cost = cost - c[x[avant(v,n)],x[v]]-c[x[v],x[apres(v,n)]]-c[x[avant(t,n)],x[t]]-c[x[t],x[apres(t,n)]]+ c[x[avant(v,n)],x[t]]+c[x[t],x[apres(v,n)]]+c[x[avant(t,n)],x[v]]+c[x[v],x[apres(t,n)]]
      end
   return new_cost
end

# donnes du probleme
n = 5
cMax = 8
c = 
[ 0.0  3.0  4.0  2.0  7.0 ;
  3.0  0.0  4.0  6.0  3.0 ;
  4.0  4.0  0.0  5.0  8.0 ;
  2.0  6.0  5.0  0.0  6.0 ;
  7.0  3.0  8.0  6.0  0.0 ]

n = 17
cMax = 900
c = [
  0 633 257  91 412 150  80 134 259 505 353 324  70 211 268 246 121;
633   0 390 661 227 488 572 530 555 289 282 638 567 466 420 745 518;
257 390   0 228 169 112 196 154 372 262 110 437 191  74  53 472 142;
 91 661 228   0 383 120  77 105 175 476 324 240  27 182 239 237  84;
412 227 169 383   0 267 351 309 338 196  61 421 346 243 199 528 297;
150 488 112 120 267   0  63  34 264 360 208 329  83 105 123 364  35;
 80 572 196  77 351  63   0  29 232 444 292 297  47 150 207 332  29;
134 530 154 105 309  34  29   0 249 402 250 314  68 108 165 349  36;
259 555 372 175 338 264 232 249   0 495 352  95 189 326 383 202 236;
505 289 262 476 196 360 444 402 495   0 154 578 439 336 240 685 390;
353 282 110 324  61 208 292 250 352 154   0 435 287 184 140 542 238;
324 638 437 240 421 329 297 314  95 578 435   0 254 391 448 157 301;
 70 567 191  27 346  83  47  68 189 439 287 254   0 145 202 289  55;
211 466  74 182 243 105 150 108 326 336 184 391 145   0  57 426  96;
268 420  53 239 199 123 207 165 383 240 140 448 202  57   0 483 153;
246 745 472 237 528 364 332 349 202 685 542 157 289 426 483   0 336;
121 518 142  84 297  35  29  36 236 390 238 301  55  96 153 336   0]


for i = 1:n
   c[i,i] = cMax*n
end

# Heuristique constructive plus proche voisin
println("Heuristique plus proche voisin...")
x = [0 for i in 1:n]
visited = [0 for i in 1:n]

x[1] = 1
visited[1] = 1

for i = 2:n
   prochaine = plusProcheVoisin(x[i-1],c,visited,n)
   visited[prochaine] = 1
   x[i] = prochaine 
end

println("Tour construite : ", x)
println("Longueur : ", cost_sol(x,n))

# Heuristique de recherche locale base sur le voisinage "echange v et t"
# strategie HillClibimg: si on trouve une solution voisine qui reduit le cout, on 
#                        accept et on change de solution et on continue a exploiter
#                        si on ne trouve pas, on fini la recherche
println("Recherche Local...")
v = 1
t = 2
cost = cost_sol(x,n)
while (v<n)
   # println(v," ",t)
   if (evaluationEchange(v,t,x,cost,n) < cost)
      # accept cette solution voisine
      aux_val = x[v]
      x[v] = x[t]
      x[t] = aux_val
      cost = cost_sol(x,n)
      println(x," Longueur ", cost)
      v = 1
      t = 2
   else
      # on passera a une autre solution voisine
      if t<n
         t = t + 1
      else
         v = v + 1
         t = v + 1
      end
   end
end
