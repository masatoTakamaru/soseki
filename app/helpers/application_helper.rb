module ApplicationHelper

  #ブラウザタグの見出し
  def full_title(page_title = '')
    base_title = t("app_name")
    if page_title.empty?
      "#{base_title} | #{t("title.home.index")}"
    else
      "#{page_title} | #{base_title}"
    end
  end

  def student_extraction  #所属クラス・学年による生徒の抽出
    @students = current_user.students
    #所属クラスのカテゴリ配列の生成
    @classes = @students.order(class_name: :asc).group(:class_name).pluck(:class_name)
    @class_list = []
    @classes.each do |c|
      @class_list.push([c,c])
    end
    if params[:class_name]
      if params[:class_name].present?
        @class_name = params[:class_name]
        @students = @students.where(class_name: @class_name)
      else
        @students = @students.order(created_at: :desc)
      end
    #学年の抽出
    elsif params[:grade]
      if params[:grade].present?
        @grade = params[:grade]
        @students = @students.where(grade: @grade)
      else
        @students = @students.order(created_at: :desc)
      end
    else
      @students = @students.all.order(created_at: :desc)
    end
  end

end
