using System.Collections.Generic;
using RMGUI.GraphView;
using UnityEngine.RMGUI;
using UnityEngine.RMGUI.StyleSheets;

namespace UnityEditor.Graphing.Drawing
{
    [StyleSheet("Assets/GraphFramework/SerializableGraph/Editor/Drawing/Styles/TitleBar.uss")]
    public class TitleBarDrawer : DataWatchContainer
    {
        TitleBarDrawData m_DataProvider;
        VisualContainer m_LeftContainer;
        VisualContainer m_RightContainer;

        public TitleBarDrawData dataProvider
        {
            get { return m_DataProvider; }
            set
            {
                if (m_DataProvider == value)
                    return;
                RemoveWatch();
                m_DataProvider = value;
                OnDataChanged();
                AddWatch();
            }
        }

        public TitleBarDrawer(TitleBarDrawData dataProvider)
        {
            classList = ClassList.empty;
            name = "TitleBar";
            zBias = 99;

            m_LeftContainer = new VisualContainer()
            {
                name = "left"
            };
            AddChild(m_LeftContainer);

            m_RightContainer = new VisualContainer()
            {
                name = "right"
            };
            AddChild(m_RightContainer);

            foreach (var leftItemData in dataProvider.leftItems)
                m_LeftContainer.AddChild(new TitleBarButtonDrawer(leftItemData));

            foreach (var rightItemData in dataProvider.rightItems)
                m_RightContainer.AddChild(new TitleBarButtonDrawer(rightItemData));

            this.dataProvider = dataProvider;
        }

        public override void OnDataChanged()
        {
            if (m_DataProvider == null)
                return;

            UpdateContainer(m_LeftContainer, m_DataProvider.leftItems);
            UpdateContainer(m_RightContainer, m_DataProvider.rightItems);
        }

        void UpdateContainer(VisualContainer container, IEnumerable<TitleBarButtonDrawData> itemDatas)
        {
            // The number of items can't change for now.
            int i = 0;
            foreach (var itemData in itemDatas)
            {
                var item = container.GetChildAtIndex(i) as TitleBarButtonDrawer;
                if (item != null)
                    item.dataProvider = itemData;
                i++;
            }
        }

        protected override object toWatch
        {
            get { return dataProvider; }
        }
    }
}
