namespace TestNel {

    use Hash.hash;

    /////////////////////////////////////////////////////////////////////////////
    // singleton                                                               //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def singleton01(): Bool = Nel.singleton(1) == Nel(1, Nil)

    @test
    def singleton02(): Bool = Nel.singleton(2) == Nel(2, Nil)

    @test
    def singleton03(): Bool = Nel.singleton('a') == Nel('a', Nil)

    /////////////////////////////////////////////////////////////////////////////
    // cons                                                                    //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def cons01(): Bool = Nel.cons(1, Nel.singleton(2)) == Nel(1, 2 :: Nil)

    @test
    def cons02(): Bool = Nel.cons(1, Nel.cons(2, Nel.singleton(3))) == Nel(1, 2 :: 3 :: Nil)

    @test
    def cons03(): Bool = Nel.cons(1, Nel.cons(2, Nel.cons(3, Nel.singleton(4)))) == Nel(1, 2 :: 3 :: 4 :: Nil)


    /////////////////////////////////////////////////////////////////////////////
    // head                                                                    //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def head01(): Bool = Nel.head(Nel(123, Nil)) == 123

    @test
    def head02(): Bool = Nel.head(Nel(123, 1 :: Nil)) == 123

    @test
    def head03(): Bool = Nel.head(Nel(123, 1 :: 2 :: Nil)) == 123

    /////////////////////////////////////////////////////////////////////////////
    // last                                                                    //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def last01(): Bool = Nel.last(Nel(123, Nil)) == 123

    @test
    def last02(): Bool = Nel.last(Nel(123, 1 :: Nil)) == 1

    @test
    def last03(): Bool = Nel.last(Nel(123, 1 :: 2 :: Nil)) == 2

    /////////////////////////////////////////////////////////////////////////////
    // init                                                                    //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def init01(): Bool = Nel.init(Nel(1, Nil)) == Nil

    @test
    def init02(): Bool = Nel.init(Nel(1, 2 :: Nil)) == 1 :: Nil

    @test
    def init03(): Bool = Nel.init(Nel(1, 2 :: 3 :: Nil)) == 1 :: 2 :: Nil

    /////////////////////////////////////////////////////////////////////////////
    // tail                                                                    //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def tail01(): Bool = Nel.tail(Nel(1, Nil)) == Nil

    @test
    def tail02(): Bool = Nel.tail(Nel(1, 2 :: Nil)) == 2 :: Nil

    @test
    def tail03(): Bool = Nel.tail(Nel(1, 2 :: 3 :: Nil)) == 2 :: 3 :: Nil

    /////////////////////////////////////////////////////////////////////////////
    // length                                                                  //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def length01(): Bool = Nel.length(Nel(1, Nil)) == 1

    @test
    def length02(): Bool = Nel.length(Nel(1, 2 :: Nil)) == 2

    @test
    def length03(): Bool = Nel.length(Nel(1, 2 :: 3 :: Nil)) == 3

    /////////////////////////////////////////////////////////////////////////////
    // append                                                                  //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def append01(): Bool = Nel(1, Nil) `Nel.append` Nel(2, Nil) == Nel(1, 2 :: Nil)

    @test
    def append02(): Bool = Nel(1, 2 :: Nil) `Nel.append` Nel(3, Nil) == Nel(1, 2 :: 3 :: Nil)

    @test
    def append03(): Bool = Nel(1, Nil) `Nel.append` Nel(2, 3 :: Nil) == Nel(1, 2 :: 3 :: Nil)

    @test
    def append04(): Bool = Nel(1, 2 :: Nil) `Nel.append` Nel(3, 4 :: Nil) == Nel(1, 2 :: 3 :: 4 :: Nil)

    @test
    def append05(): Bool = Nel(1, 2 :: 3 :: Nil) `Nel.append` Nel(4, 5 :: 6 :: Nil) == Nel(1, 2 :: 3 :: 4 :: 5 :: 6 :: Nil)

    /////////////////////////////////////////////////////////////////////////////
    // memberOf                                                                //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def memberOf01(): Bool = Nel.memberOf(0, Nel(1, Nil)) == false

    @test
    def memberOf02(): Bool = Nel.memberOf(0, Nel(1, 2 :: Nil)) == false

    @test
    def memberOf03(): Bool = Nel.memberOf(0, Nel(1, 2 :: 3 :: Nil)) == false

    @test
    def memberOf04(): Bool = Nel.memberOf(1, Nel(1, 2 :: 3 :: Nil))

    @test
    def memberOf05(): Bool = Nel.memberOf(2, Nel(1, 2 :: 3 :: Nil))

    @test
    def memberOf06(): Bool = Nel.memberOf(3, Nel(1, 2 :: 3 :: Nil))

    /////////////////////////////////////////////////////////////////////////////
    // findLeft                                                                //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def findLeft01(): Bool = Nel.findLeft(x -> x == 0, Nel(1, Nil)) == None

    @test
    def findLeft02(): Bool = Nel.findLeft(x -> x == 0, Nel(1, 2 :: Nil)) == None

    @test
    def findLeft03(): Bool = Nel.findLeft(x -> x == 0, Nel(1, 2 :: 3 :: Nil)) == None

    @test
    def findLeft04(): Bool = Nel.findLeft(x -> x == 1, Nel(1, 2 :: 3 :: Nil)) == Some(1)

    @test
    def findLeft05(): Bool = Nel.findLeft(x -> x == 2, Nel(1, 2 :: 3 :: Nil)) == Some(2)

    @test
    def findLeft06(): Bool = Nel.findLeft(x -> x == 3, Nel(1, 2 :: 3 :: Nil)) == Some(3)

    /////////////////////////////////////////////////////////////////////////////
    // findRight                                                               //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def findRight01(): Bool = Nel.findRight(x -> x == 0, Nel(1, Nil)) == None

    @test
    def findRight02(): Bool = Nel.findRight(x -> x == 0, Nel(1, 2 :: Nil)) == None

    @test
    def findRight03(): Bool = Nel.findRight(x -> x == 0, Nel(1, 2 :: 3 :: Nil)) == None

    @test
    def findRight04(): Bool = Nel.findRight(x -> x == 1, Nel(1, 2 :: 3 :: Nil)) == Some(1)

    @test
    def findRight05(): Bool = Nel.findRight(x -> x == 2, Nel(1, 2 :: 3 :: Nil)) == Some(2)

    @test
    def findRight06(): Bool = Nel.findRight(x -> x == 3, Nel(1, 2 :: 3 :: Nil)) == Some(3)

    /////////////////////////////////////////////////////////////////////////////
    // map                                                                     //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def map01(): Bool = Nel.map(x -> x + 1, Nel(1, Nil)) == Nel(2, Nil)

    @test
    def map02(): Bool = Nel.map(x -> x + 1, Nel(1, 2 :: Nil)) == Nel(2, 3 :: Nil)

    @test
    def map03(): Bool = Nel.map(x -> x + 1, Nel(1, 2 :: 3 :: Nil)) == Nel(2, 3 :: 4 :: Nil)

    /////////////////////////////////////////////////////////////////////////////
    // mapWithIndex                                                            //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def mapWithIndex01(): Bool = Nel.mapWithIndex((_, i) -> i, Nel(21, Nil)) == Nel(0, Nil)

    @test
    def mapWithIndex02(): Bool = Nel.mapWithIndex((_, i) -> i, Nel(21, 42 :: Nil)) == Nel(0, 1 :: Nil)

    @test
    def mapWithIndex03(): Bool = Nel.mapWithIndex((_, i) -> i, Nel(21, 42 :: 84 :: Nil)) == Nel(0, 1 :: 2 :: Nil)

    /////////////////////////////////////////////////////////////////////////////
    // ap                                                                      //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def ap01(): Bool = Nel.ap(Nel((x -> x+1), Nil), Nel(5, Nil)) == Nel(6, Nil)

    @test
    def ap02(): Bool = Nel.ap(Nel((x -> x+1), Nil), Nel(0, 5 :: Nil)) == Nel(1, 6 :: Nil)

    @test
    def ap03(): Bool = Nel.ap(Nel((x -> x+1), (x -> x*2) :: Nil), Nel(0, 4 :: Nil)) == Nel(1, 5 :: 0 :: 8 :: Nil)

    @test
    def ap04(): Bool = Nel.ap(Nel((x -> x+1), (x -> x*2) :: Nil), Nel(0, 4 :: 8 :: Nil)) == Nel(1, 5 :: 9 :: 0 :: 8 :: 16 :: Nil)

    @test
    def ap05(): Bool = Nel.ap(Nel((x -> x+1), (x -> x*2) :: Nil), Nel(0, 4 :: 8 :: 16 :: Nil)) == Nel(1, 5 :: 9 :: 17 :: 0 :: 8 :: 16 :: 32 :: Nil)

    /////////////////////////////////////////////////////////////////////////////
    // flatMap                                                                 //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def flatMap01(): Bool = Nel.flatMap(x -> Nel(x + 1, Nil), Nel(1, Nil)) == Nel(2, Nil)

    @test
    def flatMap02(): Bool = Nel.flatMap(x -> Nel(x + 1, Nil), Nel(1, 2 :: Nil)) == Nel(2, 3 :: Nil)

    @test
    def flatMap03(): Bool = Nel.flatMap(x -> Nel(x + 1, Nil), Nel(1, 2 :: 3 :: Nil)) == Nel(2, 3 :: 4 :: Nil)

    @test
    def flatMap04(): Bool = Nel.flatMap(x -> Nel(x, (x + 1) :: Nil), Nel(1, Nil)) == Nel(1, 2 :: Nil)

    @test
    def flatMap05(): Bool = Nel.flatMap(x -> Nel(x, (x + 1) :: Nil), Nel(1, 4 :: Nil)) == Nel(1, 2 :: 4 :: 5 :: Nil)

    @test
    def flatMap06(): Bool = Nel.flatMap(x -> Nel(x, (x + 1) :: Nil), Nel(1, 3 :: 5 :: Nil)) == Nel(1, 2 :: 3 :: 4 :: 5 :: 6 :: Nil)

    /////////////////////////////////////////////////////////////////////////////
    // reverse                                                                 //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def reverse01(): Bool = Nel.reverse(Nel(1, Nil)) == Nel(1, Nil)

    @test
    def reverse02(): Bool = Nel.reverse(Nel(1, 2 :: Nil)) == Nel(2, 1 :: Nil)

    @test
    def reverse03(): Bool = Nel.reverse(Nel(1, 2 :: 3 :: Nil)) == Nel(3, 2 :: 1 :: Nil)

    /////////////////////////////////////////////////////////////////////////////
    // replace                                                                 //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def replace01(): Bool = Nel.replace(from = 1, to = 42, Nel(1, Nil)) == Nel(42, Nil)

    @test
    def replace02(): Bool = Nel.replace(from = 7, to = 42, Nel(1, Nil)) == Nel(1, Nil)

    @test
    def replace03(): Bool = Nel.replace(from = 2, to = 42, Nel(1, 2 :: Nil)) == Nel(1, 42 :: Nil)

    @test
    def replace04(): Bool = Nel.replace(from = 7, to = 42, Nel(1, 2 :: Nil)) == Nel(1, 2 :: Nil)

    /////////////////////////////////////////////////////////////////////////////
    // permutations                                                            //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def permutations01(): Bool = Nel.permutations(Nel(1, Nil)) == Nel(1 :: Nil, Nil)

    @test
    def permutations02(): Bool = Nel.permutations(Nel(1, 2 :: Nil)) == Nel(1 :: 2 :: Nil, (2 :: 1 :: Nil) :: Nil)

    @test
    def permutations03(): Bool = Nel.permutations(Nel(1, 2 :: 3 :: Nil)) == Nel(1 :: 2 :: 3 :: Nil,
                                                                           (1 :: 3 :: 2 :: Nil) ::
                                                                           (2 :: 1 :: 3 :: Nil) ::
                                                                           (2 :: 3 :: 1 :: Nil) ::
                                                                           (3 :: 1 :: 2 :: Nil) ::
                                                                           (3 :: 2 :: 1 :: Nil) :: Nil)

    /////////////////////////////////////////////////////////////////////////////
    // subsequences                                                            //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def subsequences01(): Bool = Nel.subsequences(Nel(1, Nil)) == Nel(1 :: Nil, (Nil) :: Nil)

    @test
    def subsequences02(): Bool = Nel.subsequences(Nel(1, 2 :: Nil)) == Nel(1 :: 2 :: Nil, (1 :: Nil) :: (2 :: Nil) :: (Nil) :: Nil)

    @test
    def subsequences03(): Bool = Nel.subsequences(Nel(1, 2 :: 3 :: Nil)) == Nel(1 :: 2 :: 3 :: Nil,
                                                                           (1 :: 2 :: Nil) ::
                                                                           (1 :: 3 :: Nil) ::
                                                                           (1 :: Nil) ::
                                                                           (2 :: 3 :: Nil) ::
                                                                           (2 :: Nil) ::
                                                                           (3 :: Nil) ::
                                                                           (Nil) :: Nil)

    /////////////////////////////////////////////////////////////////////////////
    // intersperse                                                             //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def intersperse01(): Bool = Nel.intersperse(7, Nel(1, Nil)) == Nel(1, Nil)

    @test
    def intersperse02(): Bool = Nel.intersperse(7, Nel(1, 2 :: Nil)) == Nel(1, 7 :: 2 :: Nil)

    @test
    def intersperse03(): Bool = Nel.intersperse(7, Nel(1, 2 :: 3 :: Nil)) == Nel(1, 7 :: 2 :: 7 :: 3 :: Nil)

    /////////////////////////////////////////////////////////////////////////////
    // fold                                                                    //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def fold01(): Bool = Nel.fold(Nel("a", Nil)) == "a"

    @test
    def fold02(): Bool = Nel.fold(Nel((), Nil)) == ()

    @test
    def fold03(): Bool = Nel.fold(Nel("a", "b" :: "c" :: Nil)) == "abc"

    @test
    def fold04(): Bool = Nel.fold(Nel(("a", ()), ("b", ()) :: ("c", ()) :: Nil)) == ("abc", ())

    /////////////////////////////////////////////////////////////////////////////
    // foldLeft                                                                //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def foldLeft01(): Bool = Nel.foldLeft((acc, x) -> acc - x, 0, Nel(1, Nil)) == -1

    @test
    def foldLeft02(): Bool = Nel.foldLeft((acc, x) -> acc - x, 0, Nel(1, 2 :: Nil)) == -3

    @test
    def foldLeft03(): Bool = Nel.foldLeft((acc, x) -> acc - x, 0, Nel(1, 2 :: 3 :: Nil)) == -6

    /////////////////////////////////////////////////////////////////////////////
    // foldRight                                                               //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def foldRight01(): Bool = Nel.foldRight((x, acc) -> acc - x, 0, Nel(1, Nil)) == -1

    @test
    def foldRight02(): Bool = Nel.foldRight((x, acc) -> acc - x, 0, Nel(1, 2 :: Nil)) == -3

    @test
    def foldRight03(): Bool = Nel.foldRight((x, acc) -> acc - x, 0, Nel(1, 2 :: 3 :: Nil)) == -6

    /////////////////////////////////////////////////////////////////////////////
    // foldRightLazy                                                           //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def foldRightLazy01(): Bool = Nel.foldRightLazy((x, acc) -> force acc - x, 0, Nel(1, Nil)) == -1

    @test
    def foldRightLazy02(): Bool = Nel.foldRightLazy((x, acc) -> force acc - x, 0, Nel(1, 2 :: Nil)) == -3

    @test
    def foldRightLazy03(): Bool = Nel.foldRightLazy((x, acc) -> force acc - x, 0, Nel(1, 2 :: 3 :: Nil)) == -6

    /////////////////////////////////////////////////////////////////////////////
    // reduce                                                                  //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def reduce01(): Bool = Nel.reduce(Nel("a", Nil)) == "a"

    @test
    def reduce02(): Bool = Nel.reduce(Nel((), Nil)) == ()

    @test
    def reduce03(): Bool = Nel.reduce(Nel("a", "b" :: "c" :: Nil)) == "abc"

    /////////////////////////////////////////////////////////////////////////////
    // reduceLeft                                                              //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def reduceLeft01(): Bool = Nel.reduceLeft((acc, x) -> acc - x, Nel(1, Nil)) == 1

    @test
    def reduceLeft02(): Bool = Nel.reduceLeft((acc, x) -> acc - x, Nel(1, 2 :: Nil)) == -1

    @test
    def reduceLeft03(): Bool = Nel.reduceLeft((acc, x) -> acc - x, Nel(1, 2 :: 3 :: Nil)) == -4

    /////////////////////////////////////////////////////////////////////////////
    // reduceRight                                                             //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def reduceRight01(): Bool = Nel.reduceRight((x, acc) -> acc - x, Nel(1, Nil)) == 1

    @test
    def reduceRight02(): Bool = Nel.reduceRight((x, acc) -> acc - x, Nel(1, 2 :: Nil)) == 1

    @test
    def reduceRight03(): Bool = Nel.reduceRight((x, acc) -> acc - x, Nel(1, 2 :: 3 :: Nil)) == 0

    /////////////////////////////////////////////////////////////////////////////
    // count                                                                   //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def count01(): Bool = Nel.count(x -> x == 1, Nel(1, Nil)) == 1

    @test
    def count02(): Bool = Nel.count(x -> x == 2, Nel(1, Nil)) == 0

    @test
    def count03(): Bool = Nel.count(x -> x == 2, Nel(1, 2 :: 1 :: 2 :: Nil)) == 2

    @test
    def count04(): Bool = Nel.count(x -> x == 2, Nel(2, 2 :: 1 :: 2 :: Nil)) == 3


    /////////////////////////////////////////////////////////////////////////////
    // sum                                                                     //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def sum01(): Bool =
        Nel.sum(Nel(1, Nil)) == 1

    @test
    def sum02(): Bool =
        Nel.sum(Nel(1, 2 :: 3 :: Nil)) == 6

    @test
    def sum03(): Bool =
        Nel.sum(Nel(1, 2 :: 3 :: -3 :: Nil)) == 3

    @test
    def sum04(): Bool =
        Nel.sum(Nel(-1, -2 :: -3 :: -4 :: Nil)) == -10

    @test
    def sum05(): Bool =
        Nel.sum(Nel(10, -10 :: Nil)) == 0

    @test
    def sum06(): Bool = match List.range(1, 101) {
        case x :: xs => Nel.sum(Nel(x, xs)) == 5050
        case _       => unreachable!()
    }


    /////////////////////////////////////////////////////////////////////////////
    // sumWith                                                                 //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def sumWith01(): Bool =
        Nel.sumWith(x -> x + 1, Nel(1, Nil)) == 2

    @test
    def sumWith02(): Bool =
        Nel.sumWith(x -> x + 1, Nel(1, 2 :: 3 :: Nil)) == 9

    @test
    def sumWith03(): Bool =
        Nel.sumWith(x -> x + 1, Nel(1, 2 :: 3 :: -3 :: Nil)) == 7

    @test
    def sumWith04(): Bool =
        Nel.sumWith(x -> x + 1, Nel(-1, -2 :: -3 :: -4 :: Nil)) == -6

    @test
    def sumWith05(): Bool =
        Nel.sumWith(x -> x + 1, Nel(10, -10 :: Nil)) == 2


    /////////////////////////////////////////////////////////////////////////////
    // product                                                                 //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def product01(): Bool =
        Nel.product(Nel(1, Nil)) == 1

    @test
    def product02(): Bool =
        Nel.product(Nel(1, 2 :: 3 :: Nil)) == 6

    @test
    def product03(): Bool =
        Nel.product(Nel(1, 2 :: 3 :: -3 :: Nil)) == -18

    @test
    def product04(): Bool =
        Nel.product(Nel(-1, -2 :: -3 :: -4 :: Nil)) == 24

    @test
    def product05(): Bool =
        Nel.product(Nel(10, -10 :: Nil)) == -100


    /////////////////////////////////////////////////////////////////////////////
    // productWith                                                             //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def productWith01(): Bool =
        Nel.productWith(x -> x + 1, Nel(1, Nil)) == 2

    @test
    def productWith02(): Bool =
        Nel.productWith(x -> x + 1, Nel(1, 2 :: 3 :: Nil)) == 24

    @test
    def productWith03(): Bool =
        Nel.productWith(x -> x + 1, Nel(1, 2 :: 3 :: -3 :: Nil)) == -48

    @test
    def productWith04(): Bool =
        Nel.productWith(x -> x + 1, Nel(-2, -3 :: -4 :: -5 :: Nil)) == 24

    @test
    def productWith05(): Bool =
        Nel.productWith(x -> x + 1, Nel(10, -10 :: Nil)) == -99


    /////////////////////////////////////////////////////////////////////////////
    // flatten                                                                 //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def flatten01(): Bool = Nel.flatten(Nel(Nel(1, Nil), Nil)) == Nel(1, Nil)

    @test
    def flatten02(): Bool = Nel.flatten(Nel(Nel(1, Nil), Nel(2, Nil) :: Nil)) == Nel(1, 2 :: Nil)

    @test
    def flatten03(): Bool = Nel.flatten(Nel(Nel(1, Nil), Nel(2, Nil) :: Nel(3, Nil) :: Nil)) == Nel(1, 2 :: 3 :: Nil)

    @test
    def flatten04(): Bool = Nel.flatten(Nel(Nel(1, Nil), Nel(2, 3 :: Nil) :: Nel(4, 5 :: Nil) :: Nil)) == Nel(1, 2 :: 3 :: 4 :: 5 :: Nil)

    @test
    def flatten05(): Bool = Nel.flatten(Nel(Nel(1, 2 :: 3 :: Nil), Nel(4, 5 :: Nil) :: Nel(6, 7 :: Nil) :: Nil)) == Nel(1, 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: Nil)

    /////////////////////////////////////////////////////////////////////////////
    // exists                                                                  //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def exists01(): Bool = Nel.exists(x -> x == 1, Nel(1, Nil)) == true

    @test
    def exists02(): Bool = Nel.exists(x -> x == 2, Nel(1, Nil)) == false

    @test
    def exists03(): Bool = Nel.exists(x -> x == 1, Nel(1, 2 :: Nil)) == true

    @test
    def exists04(): Bool = Nel.exists(x -> x == 2, Nel(1, 2 :: Nil)) == true

    /////////////////////////////////////////////////////////////////////////////
    // forall                                                                  //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def forall01(): Bool = Nel.forall(x -> x == 1, Nel(1, Nil)) == true

    @test
    def forall02(): Bool = Nel.forall(x -> x == 2, Nel(1, Nil)) == false

    @test
    def forall03(): Bool = Nel.forall(x -> x == 1, Nel(1, 1 :: Nil)) == true

    @test
    def forall04(): Bool = Nel.forall(x -> x == 1, Nel(1, 2 :: Nil)) == false

    @test
    def forall05(): Bool = Nel.forall(x -> x == 1, Nel(2, 1 :: Nil)) == false

    /////////////////////////////////////////////////////////////////////////////
    // filter                                                                  //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def filter01(): Bool = Nel.filter(x -> x > 0, Nel(1, Nil)) == 1 :: Nil

    @test
    def filter02(): Bool = Nel.filter(x -> x > 1, Nel(1, Nil)) == Nil

    @test
    def filter03(): Bool = Nel.filter(x -> x > 0, Nel(1, 2 :: Nil)) == 1 :: 2 :: Nil

    @test
    def filter04(): Bool = Nel.filter(x -> x > 1, Nel(1, 2 :: Nil)) == 2 :: Nil

    /////////////////////////////////////////////////////////////////////////////
    // zip                                                                     //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def zip01(): Bool = Nel.zip(Nel(1, Nil), Nel(1, Nil)) == Nel((1, 1), Nil)

    @test
    def zip02(): Bool = Nel.zip(Nel(1, 2 :: Nil), Nel(1, Nil)) == Nel((1, 1), Nil)

    @test
    def zip03(): Bool = Nel.zip(Nel(1, Nil), Nel(1, 2 :: Nil)) == Nel((1, 1), Nil)

    @test
    def zip04(): Bool = Nel.zip(Nel(1, 2 :: Nil), Nel(1, 2 :: Nil)) == Nel((1, 1), (2, 2) :: Nil)

    /////////////////////////////////////////////////////////////////////////////
    // zipWith                                                                 //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def zipWith01(): Bool = Nel.zipWith((x, y) -> x + y, Nel(1, Nil), Nel(1, Nil)) == Nel(2, Nil)

    @test
    def zipWith02(): Bool = Nel.zipWith((x, y) -> x + y, Nel(1, 2 :: Nil), Nel(1, Nil)) == Nel(2, Nil)

    @test
    def zipWith03(): Bool = Nel.zipWith((x, y) -> x + y, Nel(1, Nil), Nel(1, 2 :: Nil)) == Nel(2, Nil)

    @test
    def zipWith04(): Bool = Nel.zipWith((x, y) -> x + y, Nel(1, 2 :: Nil), Nel(1, 2 :: Nil)) == Nel(2, 4 :: Nil)

    /////////////////////////////////////////////////////////////////////////////
    // unzip                                                                   //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def unzip01(): Bool = Nel.unzip(Nel((1, 1), Nil)) == (Nel(1, Nil), Nel(1, Nil))

    @test
    def unzip02(): Bool = Nel.unzip(Nel((1, 1), (2, 2) :: Nil)) == (Nel(1, 2 :: Nil), Nel(1, 2 :: Nil))

    @test
    def unzip03(): Bool = Nel.unzip(Nel((1, 1), (2, 2) :: (3, 3) :: Nil)) == (Nel(1, 2 :: 3 :: Nil), Nel(1, 2 :: 3 :: Nil))

    /////////////////////////////////////////////////////////////////////////////
    // toList                                                                  //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def toList01(): Bool = Nel.toList(Nel(1, Nil)) == 1 :: Nil

    @test
    def toList02(): Bool = Nel.toList(Nel(1, 2 :: Nil)) == 1 :: 2 :: Nil

    @test
    def toList03(): Bool = Nel.toList(Nel(1, 2 :: 3 :: Nil)) == 1 :: 2 :: 3 :: Nil

    /////////////////////////////////////////////////////////////////////////////
    // hash                                                                    //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def hash01(): Bool = hash(Nel(1, Nil)) == hash(Nel(1, Nil))

    @test
    def hash02(): Bool = hash(Nel(1, 2 :: 3 :: Nil)) == hash(Nel(1, 2 :: 3 :: Nil))

    @test
    def hash03(): Bool = hash(Nel(1, 3 :: 2 :: Nil)) != hash(Nel(1, 2 :: 3 :: Nil))

    @test
    def hash04(): Bool = hash(Nel(1, Nil)) != hash(Nel(2, Nil))

    @test
    def hash05(): Bool = hash(Nel("c", "b" :: "a" :: Nil)) != hash(Nel("c", "a" :: "b" :: Nil))

    /////////////////////////////////////////////////////////////////////////////
    // minimumBy                                                               //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def minimumBy01(): Bool = Nel.minimumBy((x, y) -> x <=> y, Nel(1, Nil)) == 1

    @test
    def minimumBy02(): Bool = Nel.minimumBy((x, y) -> x <=> y, Nel(1, 2 :: 3 :: Nil)) == 1

    @test
    def minimumBy03(): Bool = Nel.minimumBy((x, y) -> x <=> y, Nel(1, 2 :: 0 :: 3 :: Nil)) == 0

    @test
    def minimumBy04(): Bool = Nel.minimumBy((x, y) -> x <=> y, Nel(9, 5 :: 4 :: 6 :: 7 :: 3 :: Nil)) == 3

    @test
    def minimumBy05(): Bool = Nel.minimumBy((x, y) -> x <=> y, Nel(9, 5 :: 4 :: 2 :: 7 :: 10 :: Nil)) == 2

    /////////////////////////////////////////////////////////////////////////////
    // maximumBy                                                               //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def maximumBy01(): Bool = Nel.maximumBy((x, y) -> x <=> y, Nel(1, Nil)) == 1

    @test
    def maximumBy02(): Bool = Nel.maximumBy((x, y) -> x <=> y, Nel(1, 2 :: 3 :: Nil)) == 3

    @test
    def maximumBy03(): Bool = Nel.maximumBy((x, y) -> x <=> y, Nel(1, 2 :: 0 :: 3 :: Nil)) == 3

    @test
    def maximumBy04(): Bool = Nel.maximumBy((x, y) -> x <=> y, Nel(9, 5 :: 4 :: 6 :: 7 :: 3 :: Nil)) == 9

    @test
    def maximumBy05(): Bool = Nel.maximumBy((x, y) -> x <=> y, Nel(3, 5 :: 4 :: 9 :: 7 :: 10 :: Nil)) == 10

    /////////////////////////////////////////////////////////////////////////////
    // The following tests for sort functions correspond to those in TestList  //
    /////////////////////////////////////////////////////////////////////////////
    // sortWith                                                                //
    /////////////////////////////////////////////////////////////////////////////

    def cmp(x: Int32, y: Int32): Comparison =
        if (x < y) LessThan
        else if (x == y) EqualTo
        else GreaterThan

    @test
    def sortWith02(): Bool =
        Nel.sortWith(cmp, Nel(0, Nil)) == Nel(0, Nil)

    @test
    def sortWith03(): Bool =
        Nel.sortWith(cmp, Nel(0, 1 :: Nil)) == Nel(0, 1 :: Nil)

    @test
    def sortWith04(): Bool =
        Nel.sortWith(cmp, Nel(1, 0 :: Nil)) == Nel(0, 1 :: Nil)

    @test
    def sortWith05(): Bool =
        Nel.sortWith(cmp, Nel(1, 1 :: Nil)) == Nel(1, 1 :: Nil)

    @test
    def sortWith06(): Bool =
        Nel.sortWith(cmp, Nel(0, 1 :: 2 :: 3 :: 4 :: 5 :: Nil)) == Nel(0, 1 :: 2 :: 3 :: 4 :: 5 :: Nil)

    @test
    def sortWith07(): Bool =
        Nel.sortWith(cmp, Nel(5, 4 :: 3 :: 2 :: 1 :: 0 :: Nil)) == Nel(0, 1 :: 2 :: 3 :: 4 :: 5 :: Nil)

    @test
    def sortWith08(): Bool =
        Nel.sortWith(cmp, Nel(5, 3 :: 0 :: 4 :: 1 :: 2 :: Nil)) == Nel(0, 1 :: 2 :: 3 :: 4 :: 5 :: Nil)

    @test
    def sortWith09(): Bool =
        Nel.sortWith(cmp, Nel(2, 3 :: 0 :: 4 :: 1 :: 2 :: Nil)) == Nel(0, 1 :: 2 :: 2 :: 3 :: 4 :: Nil)

    @test
    def sortWith10(): Bool =
        Nel.sortWith(flip(cmp), Nel(0, 1 :: 2 :: 3 :: 4 :: 5 :: Nil)) == Nel(5, 4 :: 3 :: 2 :: 1 :: 0 :: Nil)

    @test
    def sortWith11(): Bool =
        Nel.sortWith(flip(cmp), Nel(5, 4 :: 3 :: 2 :: 1 :: 0 :: Nil)) == Nel(5, 4 :: 3 :: 2 :: 1 :: 0 :: Nil)

    @test
    def sortWith12(): Bool =
        Nel.sortWith(flip(cmp), Nel(5, 3 :: 0 :: 4 :: 1 :: 2 :: Nil)) == Nel(5, 4 :: 3 :: 2 :: 1 :: 0 :: Nil)

    @test
    def sortWith13(): Bool =
        Nel.sortWith(flip(cmp), Nel(2, 3 :: 0 :: 4 :: 1 :: 2 :: Nil)) == Nel(4, 3 :: 2 :: 2 :: 1 :: 0 :: Nil)

    /////////////////////////////////////////////////////////////////////////////
    // sort                                                                    //
    /////////////////////////////////////////////////////////////////////////////

    def testSortVsSortWith(xs: Nel[Int32]) : Bool =
        Nel.sort(xs) == Nel.sortWith(cmp, xs)

    @test
    def sort02(): Bool = testSortVsSortWith(Nel(0, Nil))

    @test
    def sort03(): Bool = testSortVsSortWith(Nel(0, 1 :: Nil))

    @test
    def sort04(): Bool = testSortVsSortWith(Nel(1, 0 :: Nil))

    @test
    def sort05(): Bool = testSortVsSortWith(Nel(1, 1 :: Nil))

    @test
    def sort06(): Bool = testSortVsSortWith(Nel(0, 1 :: 2 :: 3 :: 4 :: 5 :: Nil))

    @test
    def sort07(): Bool = testSortVsSortWith(Nel(5, 4 :: 3 :: 2 :: 1 :: 0 :: Nil))

    @test
    def sort08(): Bool = testSortVsSortWith(Nel(5, 3 :: 0 :: 4 :: 1 :: 2 :: Nil))

    @test
    def sort09(): Bool = testSortVsSortWith(Nel(2, 3 :: 0 :: 4 :: 1 :: 2 :: Nil))

    /////////////////////////////////////////////////////////////////////////////
    // sortBy                                                                  //
    /////////////////////////////////////////////////////////////////////////////

    def testSortByVsSort(a: Nel[Int32]) : Bool =
        (Nel.sortBy(identity, a) == Nel.sort(a)) and
        (Nel.sortBy(x -> 4 * x + 7, a) == Nel.sort(a)) and
        (Nel.sortBy(x -> -x, a) == Nel.sortWith(flip(cmp),a))

    @test
    def sortBy02(): Bool = testSortByVsSort(Nel(0, Nil))

    @test
    def sortBy03(): Bool = testSortByVsSort(Nel(0, 1 :: Nil))

    @test
    def sortBy04(): Bool = testSortByVsSort(Nel(1, 0 :: Nil))

    @test
    def sortBy05(): Bool = testSortByVsSort(Nel(1, 1 :: Nil))

    @test
    def sortBy06(): Bool = testSortByVsSort(Nel(0, 1 :: 2 :: 3 :: 4 :: 5 :: Nil))

    @test
    def sortBy07(): Bool = testSortByVsSort(Nel(5, 4 :: 3 :: 2 :: 1 :: 0 :: Nil))

    @test
    def sortBy08(): Bool = testSortByVsSort(Nel(5, 3 :: 0 :: 4 :: 1 :: 2 :: Nil))

    @test
    def sortBy09(): Bool = testSortByVsSort(Nel(2, 3 :: 0 :: 4 :: 1 :: 2 :: Nil))


    /////////////////////////////////////////////////////////////////////////////
    // toIterator                                                              //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def toIterator01(): Bool & Impure =
        Nel(1, 2 :: 3 :: Nil) |> Nel.toIterator |> Iterator.toNel == Some(Nel(1, 2 :: 3 :: Nil))

    @test
    def toIterator02(): Bool & Impure =
        Nel(-100, List.range(-99, 100)) |> Nel.toIterator |> Iterator.toList == List.range(-100, 100)

    /////////////////////////////////////////////////////////////////////////////
    // toMapWith                                                               //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def toMapWith01(): Bool =
        Nel.toMapWith(x -> 0 * x, Nel(7, 1 :: 3 :: 6 :: Nil)) == Map#{1 => 0, 3 => 0, 6 => 0, 7 => 0}

    @test
    def toMapWith02(): Bool =
        Nel.toMapWith(x -> 2 * x, Nel(7, 1 :: 3 :: 6 :: Nil)) == Map#{1 => 2, 3 => 6, 6 => 12, 7 => 14}

    @test
    def toMapWith03(): Bool =
        Nel.toMapWith(x -> x + 10, Nel(7, 1 :: 3 :: 6 :: Nil)) == Map#{1 => 11, 3 => 13, 6 => 16, 7 => 17}

    @test
    def toMapWith04(): Bool =
        Nel.toMapWith(x -> x + 10, Nel(7, 3 :: 6 :: 1 :: Nil)) == Map#{1 => 11, 3 => 13, 6 => 16, 7 => 17}


    /////////////////////////////////////////////////////////////////////////////
    // join                                                                    //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def join01(): Bool =
        Nel.join(",", Nel(1, Nil)) == "1"

    @test
    def join02(): Bool =
        Nel.join(",", Nel(1, 2 :: 3 :: Nil)) == "1,2,3"

    @test
    def join03(): Bool =
        Nel.join(",", Nel("1", "2" :: "3" :: Nil)) == "1,2,3"


    /////////////////////////////////////////////////////////////////////////////
    // joinWith                                                                //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def joinWith01(): Bool =
        Nel.joinWith(x -> "${x + 1}", ",", Nel(1, Nil)) == "2"

    @test
    def joinWith02(): Bool =
        Nel.joinWith(x -> "${x + 1}", ",", Nel(1, 2 :: 3 :: Nil)) == "2,3,4"

    @test
    def joinWith03(): Bool =
        Nel.joinWith(x -> x + x, ",", Nel("1", "2" :: "3" :: Nil)) == "11,22,33"

}
