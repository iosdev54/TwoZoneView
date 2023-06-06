# TwoZoneView (Test app., SwiftUI)

### View consists of two zones - yellow and blue. The yellow zone can process touches with many fingers at the same time. The blue zone can handle only one finger. Also, the blue zone can be hidden, and then the yellow zone occupies the entire view area. This view must be able to change its size and position. The four outer corners are always rounded.

### Necessary:
1. Create such a view using SwiftUI, and place it on the screen.
2. From the top of the screen, create:
- Two text fields for the dimensions of this view (height and width). Allowed range: `0 <= value <= Int.max`. 
- Two fields for its position (x, y). Allowed range: `Int.min <= value <= Int.max`.
- The button when pressed, the view will change its position and size.
When clicking, you need to validate for incorrect values and show errors to the user.
- button/toggle/etc to be able to hide the blue zone (show view without it or with it).
3. Implement the TwoZoneHandler interface and output data from its functions to output.
```
protocol TwoZoneHandler {
    func onBlueZoneEvent(isPressed: Bool)
    func onYellowZoneEvent(idx: Int, // finger index
                           x: Double, // coordinate in percentage of width (0...100)
                           y: Double // coordinate in percentage of height (0...100)
    )
}
```
### Requirements:
When the yellow zone is touched, onYellowZoneEvent() should be called, passing data about this finger there: the index of the finger on this zone and the position in percent relative to the width and height.
When the finger is removed or moved, nothing needs to be removed.
The blue zone should call onBlueZoneEvent() with the parameter true when the finger touched the zone and with the parameter false when the finger that touched the zone was removed from the screen. This zone should be able to process only one finger and ignore the others.
The blue zone should occupy 30% of the total height of the view, the yellow zone - the rest.

### Pay attention:
- Multi-touch of the yellow zone can be processed using UIKit using UIViewRepresentable as a help.
- Both zones must be able to handle touches at the same time.
- The format of data output in the output can be any, the main thing is that it is clear what kind of data is there.
- If possible, separate the logic from the view (using MVVM, MVP, MVC, etc).
- Finger index - it means that if there are two fingers on the screen, then the indexes will be [0,1]. If you remove the finger under the index 0, then the index of the finger 1 is not will change If you turn your finger again after that, it will be [0,1] again.
- Choose the corner radius, initial position and view size yourself.
- What text or how exactly to show size and position errors - decide for yourself (text/alert/etc.)

### Screenshots:
![1](https://github.com/iosdev54/TwoZoneView/assets/107141073/c84a63b1-e90a-4845-8082-4c16290994ba)
![2](https://github.com/iosdev54/TwoZoneView/assets/107141073/c584e204-fa27-48a5-8397-6e41292c830e)
