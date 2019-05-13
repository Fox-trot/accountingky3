﻿#Область СлужебныйПрограммныйИнтерфейс

Функция МенеджерыЛогическихХранилищ() Экспорт
	
	ВсеМенеджерыЛогическихХранилищ = Новый Соответствие;
	
	ОбщийМодуль_ДемоЛогическоеХранилище = Метаданные.ОбщиеМодули.Найти("_ДемоЛогическоеХранилище");
	
	Если ОбщийМодуль_ДемоЛогическоеХранилище <> Неопределено Тогда
		
		ВсеМенеджерыЛогическихХранилищ.Вставить("files", Вычислить(ОбщийМодуль_ДемоЛогическоеХранилище.Имя));
		
	КонецЕсли;
	
	ПередачаДанныхВстраивание.МенеджерыЛогическихХранилищ(ВсеМенеджерыЛогическихХранилищ);
	ПередачаДанныхПереопределяемый.МенеджерыЛогическихХранилищ(ВсеМенеджерыЛогическихХранилищ);
	
	Возврат Новый ФиксированноеСоответствие(ВсеМенеджерыЛогическихХранилищ);
	
КонецФункции

Функция МенеджерыФизическихХранилищ() Экспорт
	
	ВсеМенеджерыФизическихХранилищ = Новый Соответствие;
	
	ОбщийМодуль_ДемоФизическоеХранилище = Метаданные.ОбщиеМодули.Найти("_ДемоФизическоеХранилище");
	
	Если ОбщийМодуль_ДемоФизическоеХранилище <> Неопределено Тогда
		
		ВсеМенеджерыФизическихХранилищ.Вставить("tmp", Вычислить(ОбщийМодуль_ДемоФизическоеХранилище.Имя));
		
	КонецЕсли;
	
	ПередачаДанныхВстраивание.МенеджерыФизическихХранилищ(ВсеМенеджерыФизическихХранилищ);
	ПередачаДанныхПереопределяемый.МенеджерыФизическихХранилищ(ВсеМенеджерыФизическихХранилищ);
	
	Возврат Новый ФиксированноеСоответствие(ВсеМенеджерыФизическихХранилищ);
	
КонецФункции

#КонецОбласти