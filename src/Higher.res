// module type StarToStar = sig
//   type 'a t
// end
module type StarToStar = {
  type t<'a>
}

// module Tree (F : StarToStar) =
// struct
//     type 'a tree = Leaf of 'a | Node of 'a tree F.t
// end

module Tree = (Container: StarToStar) => {
  type tree<'a> = Leaf('a) | Node('a, Container.t<'a>)
}
module type TreeLike = (Container: StarToStar) =>
{
  type tree<'a> = Leaf('a) | Node('a, Container.t<'a>)
}
// module RoseTree = Tree (struct
//   type 'a t = 'a list
// end)
module type RoseTreeType = {
  type tree<'a> = Leaf('a) | Node('a, list<'a>)
}
// Annotation here is optional
module RoseTree: RoseTreeType = Tree({
  type t<'a> = list<'a>
})
// module BinTree = Tree (struct
//   type 'a t = 'a * 'a
// end)
module BinTree = Tree({
  type t<'a> = ('a, 'a)
})
// module AnnTree = Tree (struct
//   type 'a t = string * 'a * 'a
// end)
module AnnTree = Tree({
  type t<'a> = (string, 'a, 'a)
})
// let sas x = function
// | RoseTree.Leaf x -> ("Leaf of" ^ x)
// | RoseTree.Node s -> ""
let sumStuff = (x, m) => {
  let module(M: TreeLike) = m
  switch x {
  | RoseTree.Leaf(content) => content
  | _ => 1
  }
}
