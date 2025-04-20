$(function () {
    function display(bool) {
        if (bool) {
            $("#guide_manager").show();
        } else {
            $("#guide_manager").hide();
        }
    }
    display(false)
    window.addEventListener('message', function(event) {
        
        let item                    = event.data;
        let charscount              = item.totalchars;
        let CharsPlayer             = item.CharsPlayer;

        if (item.type === "ui") {
            if (item.status == true) {
                AllCategories();
                function AllCategories(){

                    $("#title").html('');
                    $("#title").html('Select your character');
                    $("#categories").html('');
                    $("#contents").html('');
                    $(".selected").hide();
                    $(".prev").hide();

                    if (charscount == 1){
                        $('#categories').append(`
                        <div class="col-lg-12" onclick="play()">
                            <div class="infinity_category" id="1" data-id="`+CharsPlayer.charid+`" 
                            data-rpinfos="`+CharsPlayer.firstname+` `+CharsPlayer.lastname+`" 
                            data-cash="`+CharsPlayer.cash+`" 
                            data-golds="`+CharsPlayer.golds+`" 
                            data-rank="`+CharsPlayer.rank+`" 
                            data-job="`+CharsPlayer.job+`" 
                            data-jobgrade="`+CharsPlayer.jobgrade+`" 
                            data-nation="`+CharsPlayer.nationality+`" 
                            data-years="`+CharsPlayer.years+`" 
                            data-gang="`+CharsPlayer.gang+`" 
                            data-gangrank="`+CharsPlayer.gangrank+`" 
                            data-hp="`+CharsPlayer.hp+`" 
                            data-drink="`+CharsPlayer.drink+`" 
                            data-food="`+CharsPlayer.food+`" 
                            style="background: url('design/raw.jpg');">
                                <div class="infinity_content d-flex flex-column">
                                    <span class="category_title">${CharsPlayer.firstname} ${CharsPlayer.lastname}</span>
                                    <span class="category_desc">${CharsPlayer.cash}$</span>
                                </div>
                                <div class="overlay"></div>
                            </div>
                        </div>`)
                    }else{
                        let i =0;
                        for (single in CharsPlayer) {
                            i++;
                            if(CharsPlayer[single].charid == i){
                                $('#categories').append(`
                                <div class="col-lg-12" onclick="play()">
                                    <div class="infinity_category" id="`+i+`" data-id="`+CharsPlayer[single].charid+`" 
                                    data-rpinfos="`+CharsPlayer[single].firstname+` `+CharsPlayer[single].lastname+`" 
                                    data-cash="`+CharsPlayer[single].cash+`" 
                                    data-golds="`+CharsPlayer[single].golds+`" 
                                    data-rank="`+CharsPlayer[single].rank+`" 
                                    data-job="`+CharsPlayer[single].job+`" 
                                    data-jobgrade="`+CharsPlayer[single].jobgrade+`" 
                                    data-nation="`+CharsPlayer[single].nationality+`" 
                                    data-years="`+CharsPlayer[single].years+`" 
                                    data-gang="`+CharsPlayer[single].gang+`" 
                                    data-gangrank="`+CharsPlayer[single].gangrank+`" 
                                    data-hp="`+CharsPlayer[single].hp+`" 
                                    data-drink="`+CharsPlayer[single].drink+`" 
                                    data-food="`+CharsPlayer[single].food+`" 
                                    style="background: url('design/raw.jpg');">
                                        <div class="infinity_content d-flex flex-column">
                                            <span class="category_title">${CharsPlayer[single].firstname} ${CharsPlayer[single].lastname}</span>
                                            <span class="category_desc">${CharsPlayer[single].cash}$</span>
                                        </div>
                                        <div class="overlay"></div>
                                    </div>
                                </div>`)
                            }
                        }
                    }
                    $('.infinity_category').unbind('click').click(function(event){
                        let cat                 = document.getElementById(this.id);
                        let PedID               = cat.dataset.id;
                        let RPInfos             = cat.dataset.rpinfos;
                        let cash                = cat.dataset.cash;
                        let golds               = cat.dataset.golds;
                        let rank                = cat.dataset.rank;
                        let job                 = cat.dataset.job;
                        let jobgrade            = cat.dataset.jobgrade;
                        let hp                  = cat.dataset.hp;
                        let drink               = cat.dataset.drink;
                        let food                = cat.dataset.food;
                        let nation              = cat.dataset.nation;
                        let years               = cat.dataset.years;
                        let gang                = cat.dataset.gang;
                        let gangrank            = cat.dataset.gangrank;
                        let colorfood   = '<span class="text-success">'+food+'</span>'
                        let colordrink  = '<span class="text-success">'+drink+'</span>'
                        let color       = '<span class="text-success">'+hp+'</span>'

                        if(hp <= 50){
                            let color   = '<span class="text-danger">'+hp+'</span>'
                        }
                        if(drink <= 50){
                            let colordrink   = '<span class="text-danger">'+drink+'</span>'
                        }
                        if(drink <= 50){
                            let colorfood  = '<span class="text-danger">'+food+'</span>'
                        }
                        $("#title").html('');
                        $("#title").html(`<span style="color:var(--redm);"><b>${RPInfos}</b></span>`);
                        $("#contents").html('');
                        $("#contents").unbind('click').html(`
                        <div class='col-lg-12 d-flex my-2'>
                            <div class="me-auto my-auto"><b>Nation</b></div>
                            <div class="ms-auto my-auto">${nation}</div>
                        </div>
                        <div class='col-lg-12 d-flex my-2'>
                            <div class="me-auto my-auto"><b>Years</b></div>
                            <div class="ms-auto my-auto">${years}</div>
                        </div>
                        <div class='col-lg-12 d-flex my-2'>
                            <div class="me-auto my-auto"><b>Cash</b></div>
                            <div class="ms-auto my-auto">${cash}$</div>
                        </div>
                        <div class='col-lg-12 d-flex my-2'>
                            <div class="me-auto my-auto"><b>Golds</b></div>
                            <div class="ms-auto my-auto">${golds}</div>
                        </div>
                        <div class='col-lg-12 d-flex my-2'>
                            <div class="me-auto my-auto"><b>Server Rank</b></div>
                            <div class="ms-auto my-auto text-uppercase">${rank}</div>
                        </div>
                        <div class='col-lg-12 d-flex my-2'>
                            <div class="me-auto my-auto"><b>Job</b></div>
                            <div class="ms-auto my-auto">${job}</div>
                        </div>
                        <div class='col-lg-12 d-flex my-2'>
                            <div class="me-auto my-auto"><b>Job Rank</b></div>
                            <div class="ms-auto my-auto">${jobgrade}</div>
                        </div>
                        <div class='col-lg-12 d-flex my-2'>
                            <div class="me-auto my-auto"><b>Gang</b></div>
                            <div class="ms-auto my-auto">${gang}</div>
                        </div>
                            <div class='col-lg-12 d-flex my-2'>
                            <div class="me-auto my-auto"><b>Gang Rank</b></div>
                            <div class="ms-auto my-auto">${gangrank}</div>
                        </div>
                        <div class='col-lg-12 d-flex my-2'>
                            <div class="me-auto my-auto"><b>HP</b></div>
                            <div class="ms-auto my-auto">${color} / 100</div>
                        </div>
                        <div class='col-lg-12 d-flex my-2'>
                            <div class="me-auto my-auto"><b>Thirst</b></div>
                            <div class="ms-auto my-auto">${colordrink} / 100</div>
                        </div>
                        <div class='col-lg-12 d-flex my-2 infinity_select'>
                            <div class="me-auto my-auto"><b>Food</b></div>
                            <div class="ms-auto my-auto">${colorfood} / 100</div>
                        </div>`);

                            // Delay for prevent lot of request and bug duplicate peds
                            setTimeout(() => {
                                $(".prev").show();
                            }, "5000")

                            $("#categories").html('');
                            $(".selected").show();
                     
                            $.post(`https://${GetParentResourceName()}/PedID`, JSON.stringify({
                                PedID : PedID
                            }));

                            $.post(`https://${GetParentResourceName()}/SelectPedID`, JSON.stringify({
                                PedID : PedID
                            }));
                        return
                    });
                }
                $('.previous').unbind('click').click(function(event){
                    AllCategories();
                    $.post(`https://${GetParentResourceName()}/Previous`, JSON.stringify({}));
                });
                $('.exit').unbind('click').click(function(event){
                    $("#categories").html('');
                    $("#contents").html('');
                    $.post(`https://${GetParentResourceName()}/exit`, JSON.stringify({}));
                    return
                });
                display(true)
            } else {
                display(false)
            }
        }
    });
});