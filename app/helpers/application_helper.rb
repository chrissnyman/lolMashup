module ApplicationHelper

    def item_image(item_id)
        cur_item = Item.where(id: item_id).first
        item_html = ""
        if cur_item.present?
            item_html = "<img class='results-item-img' src='http://ddragon.leagueoflegends.com/cdn/11.1.1/img/item/#{cur_item.imagename}' data-toggle='tooltip'  title='#{cur_item.name}'>"
        end 
        
        return item_html
    end
    
end
