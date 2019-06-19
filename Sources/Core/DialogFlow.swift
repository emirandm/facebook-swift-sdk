// Copyright (c) 2014-present, Facebook, Inc. All rights reserved.
//
// You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
// copy, modify, and distribute this software in source code or binary form for use
// in connection with the web services and APIs provided by Facebook.
//
// As with any software that integrates with the Facebook platform, your use of
// this software is subject to the Facebook Developer Principles and Policies
// [http://developers.facebook.com/policy/]. This copyright notice shall be
// included in all copies or substantial portions of the software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

// swiftlint:disable nesting

import Foundation

extension ServerConfiguration {
  struct DialogFlow: Codable {
    let name: FlowName
    let shouldUseNativeFlow: Bool
    let shouldUseSafariVC: Bool

    init(remote: Remote.ServerConfiguration.DialogFlow) {
      name = FlowName(value: remote.name)
      shouldUseNativeFlow = remote.shouldUseNativeFlow ?? false
      shouldUseSafariVC = remote.shouldUseSafariVC ?? false
    }

    enum FlowName: CustomStringConvertible, Equatable, Codable {
      func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let key: CodingKeys

        switch self {
        case .default:
          key = .default

        case .login:
          key = .login

        case .sharing:
          key = .sharing

        case .other:
          key = .other
        }

        try container.encode(description, forKey: key)
      }

      init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if try container.decodeIfPresent(String.self, forKey: .default) != nil {
          self = .default
        } else if try container.decodeIfPresent(String.self, forKey: .login) != nil {
          self = .login
        } else if try container.decodeIfPresent(String.self, forKey: .sharing) != nil {
          self = .sharing
        } else {
          let value = try container.decode(String.self, forKey: .other)
          self = .other(value)
        }
      }

      case `default`
      case login
      case sharing
      case other(String)

      var description: String {
        switch self {
        case .default:
          return "default"

        case .login:
          return "login"

        case .sharing:
          return "sharing"

        case .other(let value):
          return value
        }
      }

      init(value: String) {
        switch value {
        case "default":
          self = .default

        case "login":
          self = .login

        case "sharing":
          self = .sharing

        default:
          self = .other(value)
        }
      }

      enum CodingKeys: String, CodingKey {
        case `default`
        case login
        case sharing
        case other
      }
    }
  }
}