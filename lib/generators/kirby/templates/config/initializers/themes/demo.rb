::Kirby::Theme.register do |theme|

  theme.name = 'demo'
  theme.title = 'Demo theme'

  theme.page_parts = [{
                        name:           'line',
                        title:          'Line',
                        partable_type:  'Kirby::Line'
                      }, {
                        name:           'text',
                        title:          'Text',
                        partable_type:  'Kirby::Text'
                      }, {
                        name:           'image',
                        title:          'Image',
                        partable_type:  'Kirby::Image'
                      }, {
                        name:           'image_collection',
                        title:          'Image collection',
                        partable_type:  'Kirby::ImageCollection'
                      }, {
                        name:           'attachment',
                        title:          'Attachment',
                        partable_type:  'Kirby::Attachment'
                      }, {
                        name:           'attachment_collection',
                        title:          'Attachment collection',
                        partable_type:  'Kirby::AttachmentCollection'
                      }, {
                        name:           'structure',
                        title:          'Structure',
                        partable_type:  'Kirby::Structure'
                      }]

  theme.structures = [{
                        name: 'structure',
                        structure_parts: [{
                                            name:           'title',
                                            title:          'Title',
                                            partable_type:  'Kirby::Line'
                                          }, {
                                            name:           'description',
                                            title:          'Description',
                                            partable_type:  'Kirby::Text'
                                          }]
                      }]

  theme.layout_parts = [{
                          name:           'line',
                          title:          'Line',
                          partable_type:  'Kirby::Line'
                        }]

  theme.view_templates = [{
                            name: 'homepage',
                            title: 'Homepage',
                            page_parts: ['text'],
                          }, {
                            name: 'show',
                            title: 'Default',
                            usage: 'Use for your content',
                            page_parts: ['text']
                          }, {
                            name: 'demo',
                            title: 'Demo',
                            description: 'Contains examples of every page part',
                            page_parts: ['line', 'text', 'image', 'image_collection', 'attachment', 'attachment_collection', 'structure']
                          }]

  theme.custom_pages = [{
                          name:           'homepage',
                          title:          'Homepage',
                          deletable:      false,
                          view_template:  'homepage'
                        }, {
                          name:           'demo',
                          title:          'Demo',
                          deletable:      true,
                          view_template:  'demo'
                        }]

  theme.plugins = ['reviews']

end
