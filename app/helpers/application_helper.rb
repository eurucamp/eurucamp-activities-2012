module ApplicationHelper

   def wrapped(el = :div, attrs = {}, &block)
    capture_haml do
      haml_tag el, attrs do
        haml_tag :div, :class => 'wrapper', &block
      end
    end
  end

  def image(url, sizes = [], attrs = {})
    attrs[:src] = url
    attrs = inject_class(attrs, 'resp')
    sizes.each do |size|
      attrs[:"data-#{size}"] = image_url_for_size(url, size)
    end
    capture_haml do
      haml_tag :img, attrs
    end
  end

private

  def inject_class(attributes, klass)
    attrs = attributes.dup
    attrs[:class] ||= ''
    attrs[:class] << " #{klass}"
    attrs[:class].strip!
    attrs
  end

  def image_url_for_size(url, size)
    extension = File.extname(url)
    url.chomp(extension) + '-' + size.to_s + extension
  end
end
