namespace :services do
  desc "Seeds services"
  task seeds_services: :environment do
    Spree::Service.create!([{
      name: "Default test service",
      fields: "[\n  {\n    \"type\": \"text\",\n    \"label\": \"Describe the space you would like cleaned\",\n    \"className\": \"form-control\",\n    \"name\": \"Describe-the-space-you-would-like-cleaned\",\n    \"subtype\": \"text\"\n  },\n  {\n    \"type\": \"text\",\n    \"label\": \"No. of employees\",\n    \"className\": \"form-control\",\n    \"name\": \"No-of-employees\",\n    \"subtype\": \"text\"\n  },\n  {\n    \"type\": \"text\",\n    \"label\": \"Size in square feet\",\n    \"className\": \"form-control\",\n    \"name\": \"Size-in-square-feet\",\n    \"subtype\": \"text\"\n  },\n  {\n    \"type\": \"file\",\n    \"label\": \"Upload office floor plan\",\n    \"className\": \"form-control\",\n    \"name\": \"Upload-office-floor-plan\",\n    \"subtype\": \"file\"\n  }\n]",
      slug: "default-test-service",
      description: "just for testing service",
      meta_title: "test service",
      meta_keywords: "test,service",
      meta_description: "just for testing service"
    },
    {
      name: "Catering test service",
      fields: "[\n  {\n    \"type\": \"header\",\n    \"subtype\": \"h3\",\n    \"label\": \"Contact Information\"\n  },\n  {\n    \"type\": \"text\",\n    \"required\": true,\n    \"label\": \"Name\",\n    \"className\": \"form-control\",\n    \"name\": \"name\",\n    \"subtype\": \"text\"\n  },\n  {\n    \"type\": \"text\",\n    \"label\": \"Company\",\n    \"className\": \"form-control\",\n    \"name\": \"company\",\n    \"subtype\": \"text\"\n  },\n  {\n    \"type\": \"text\",\n    \"required\": true,\n    \"label\": \"Phone\",\n    \"className\": \"form-control\",\n    \"name\": \"phone\",\n    \"subtype\": \"text\"\n  },\n  {\n    \"type\": \"text\",\n    \"required\": true,\n    \"label\": \"Address\",\n    \"className\": \"form-control\",\n    \"name\": \"address\",\n    \"subtype\": \"text\"\n  },\n  {\n    \"type\": \"text\",\n    \"subtype\": \"email\",\n    \"label\": \"Email\",\n    \"className\": \"form-control\",\n    \"name\": \"email\"\n  },\n  {\n    \"type\": \"header\",\n    \"subtype\": \"h3\",\n    \"label\": \"Default of Event\"\n  },\n  {\n    \"type\": \"text\",\n    \"required\": true,\n    \"label\": \"Type of Catering\",\n    \"className\": \"form-control\",\n    \"name\": \"type-of-catering\",\n    \"subtype\": \"text\"\n  },\n  {\n    \"type\": \"date\",\n    \"label\": \"Date of Event\",\n    \"className\": \"form-control\",\n    \"name\": \"date-of-event\"\n  },\n  {\n    \"type\": \"text\",\n    \"label\": \"Time of Event\",\n    \"className\": \"form-control\",\n    \"name\": \"time-of-event\",\n    \"subtype\": \"text\"\n  },\n  {\n    \"type\": \"number\",\n    \"label\": \"No.of Guest\",\n    \"className\": \"form-control\",\n    \"name\": \"no-of-guest\"\n  },\n  {\n    \"type\": \"text\",\n    \"required\": true,\n    \"label\": \"Venue\",\n    \"className\": \"form-control\",\n    \"name\": \"venue\",\n    \"subtype\": \"text\"\n  },\n  {\n    \"type\": \"number\",\n    \"required\": true,\n    \"label\": \"Budget per Pax\",\n    \"className\": \"form-control\",\n    \"name\": \"budget-per-pax\"\n  },\n  {\n    \"type\": \"textarea\",\n    \"label\": \"Additional Information\",\n    \"className\": \"form-control\",\n    \"name\": \"additional-information\",\n    \"subtype\": \"textarea\"\n  }\n]",
      slug: "cateing-test-service",
      description: "just for testing service",
      meta_title: "test service",
      meta_keywords: "test,service",
      meta_description: "just for testing service"
    }])
  end

end
