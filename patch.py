import re

with open("Sport Mob/Features/TeamDetailsScreen/views/TeamPlayersTableViewCell.xib", "r") as f:
    content = f.read()

# Remove the constraints inside the stack view
content = re.sub(
    r'<constraints>\s*<constraint firstItem="q0J-UU-0qk" firstAttribute="leading"[^>]+/>\s*</constraints>',
    '',
    content
)

# Add horizontalCompressionResistancePriority to nHp-uV-RSh
content = content.replace(
    '<label opaque="NO" userInteractionEnabled="NO" contentMode="left" horizontalHuggingPriority="251" verticalHuggingPriority="251" text="10"',
    '<label opaque="NO" userInteractionEnabled="NO" contentMode="left" horizontalHuggingPriority="251" verticalHuggingPriority="251" horizontalCompressionResistancePriority="751" text="10"'
)

# Add constraints to the superview constraints
new_constraints = """
                    <constraint firstItem="nHp-uV-RSh" firstAttribute="leading" relation="greaterThanOrEqual" secondItem="d7z-6k-RWw" secondAttribute="trailing" constant="8" id="lSj-rR-bB1"/>
                    <constraint firstAttribute="trailing" relation="greaterThanOrEqual" secondItem="2ID-vb-MFI" secondAttribute="trailing" constant="16" id="mTk-sS-cC2"/>
"""

content = content.replace(
    '<constraint firstItem="d7z-6k-RWw" firstAttribute="leading" secondItem="6YL-9N-2bB" secondAttribute="trailing" constant="18" id="ycf-gw-oJ7"/>',
    '<constraint firstItem="d7z-6k-RWw" firstAttribute="leading" secondItem="6YL-9N-2bB" secondAttribute="trailing" constant="18" id="ycf-gw-oJ7"/>' + new_constraints
)

with open("Sport Mob/Features/TeamDetailsScreen/views/TeamPlayersTableViewCell.xib", "w") as f:
    f.write(content)
