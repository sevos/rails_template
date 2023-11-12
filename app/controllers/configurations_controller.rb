class ConfigurationsController < ApplicationController
    def ios_v1
      render json: {
        settings: [],
        rules: [
          {
            patterns: [
            ],
            properties: {
              presentation: "replace"
            }
          },
          # {
          #   patterns: [
          #     "/new$",
          #     "/edit$",
          #   ],
          #   properties: {
          #     context: "modal",
          #     presentation: "replace"
          #   },
          #   comment: "Present forms and custom modal path as modals."
          # },
          {
            patterns: [
              "^/$"
            ],
            properties: {
              presentation: "replace"
            },
            comment: "Reset navigation stacks when visiting root page."
          }
        ]
      }
    end
  end
