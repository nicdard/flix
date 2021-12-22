/*
 * Copyright 2020 Esben Bjerre
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
namespace TestMutMap {

    /////////////////////////////////////////////////////////////////////////////
    // sameElements                                                            //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def sameElements01(): Bool & Impure =
        let m = MutMap.empty(): MutMap[Int32, Int32];
        let m2 = MutMap.empty(): MutMap[Int32, Int32];

        MutMap.sameElements(m, m2)

    @test
    def sameElements02(): Bool & Impure =
        let m = MutMap.empty();
        MutMap.put!(1, "a", m);

        let m2 = MutMap.empty();
        MutMap.put!(1, "a", m2);

        MutMap.sameElements(m, m2)

    @test
    def sameElements03(): Bool & Impure =
        let m = MutMap.empty();
        MutMap.put!(1, "a", m);
        MutMap.put!(1, "b", m);

        let m2 = MutMap.empty();
        MutMap.put!(1, "a", m2);

        not MutMap.sameElements(m, m2)

    @test
    def sameElements04(): Bool & Impure =
        let m = MutMap.empty();
        MutMap.put!(1, "a", m);
        MutMap.put!(2, "b", m);

        let m2 = MutMap.empty();
        MutMap.put!(1, "a", m2);

        not MutMap.sameElements(m, m2)

    @test
    def sameElements05(): Bool & Impure =
        let m = MutMap.empty();
        MutMap.put!(1, "a", m);

        let m2 = MutMap.empty();
        MutMap.put!(1, "a", m2);
        MutMap.put!(2, "b", m2);

        not MutMap.sameElements(m, m2)

    @test
    def sameElements06(): Bool & Impure =
        let m = MutMap.empty();
        MutMap.put!(2, "b", m);
        MutMap.put!(3, "c", m);
        MutMap.put!(1, "a", m);

        let m2 = MutMap.empty();
        MutMap.put!(1, "a", m2);
        MutMap.put!(2, "b", m2);
        MutMap.put!(3, "c", m2);

        MutMap.sameElements(m, m2)

    /////////////////////////////////////////////////////////////////////////////
    // foldRightL                                                              //
    /////////////////////////////////////////////////////////////////////////////
    @test
    def foldRightL01(): Bool & Impure = MutMap.foldRightL((v, s) -> force s + v, 0, MutMap.empty()) == 0

    @test
    def foldRightL02(): Bool & Impure = MutMap.foldRightL((v, s) -> force s + v, 0, MutMap.singleton(1, 2)) == 2

    @test
    def foldRightL03(): Bool & Impure =
        let m = MutMap(ref Map#{1 => 2, 3 => 4});
        MutMap.foldRightL((v, s) -> force s + v, 0, m) == 6

    @test
    def foldRightL04(): Bool & Impure =
        let m = MutMap(ref Map#{1 => 2, 3 => 4, 5 => 6});
        MutMap.foldRightL((v, s) -> force s + v, 0, m) == 12

}
