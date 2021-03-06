class Admin::CategoriesController < Admin::BaseController
  cache_sweeper :blog_sweeper

  def index; redirect_to :action => 'new' ; end
  def edit; new_or_edit;  end

  def new
    respond_to do |format|
      format.html { new_or_edit }
      format.js {
        @category = Category.new
      }
    end
  end

  def destroy
    @record = Category.find(params[:id])
    return(render 'admin/shared/destroy') unless request.post?

    @record.destroy
    redirect_to :action => 'new'
  end

  def create
    @category = Category.new(params[:category])

    save_category
  end

  private

  def new_or_edit
    @categories = Category.find(:all)
    if params[:id].nil?
      @action = '/admin/categories/edit'
    else
      @action = '/admin/categories/edit'
      @id = Category.find(params[:id]).id
    end
    @category = Category.find(params[:id]) unless params[:id].nil?
    @category.attributes = params[:category] unless @category.nil?
    if request.post?
      respond_to do |format|
        format.html { save_category }
        format.js do
          @category.save
          @article = Article.new
          @article.categories << @category
          return render(:partial => 'admin/content/categories')
        end
      end
      return
    end
    render 'new'
  end

  def save_category
    @category ||= Category.new(params[:category])
    begin
    if @category.save!
      flash[:notice] = _('Category was successfully saved.')
    else
      flash[:error] = _('Category could not be saved.')
    end
    rescue
      flash[:error] = _('Category could not be saved.')
      end
    redirect_to :action => 'new'
  end

end
