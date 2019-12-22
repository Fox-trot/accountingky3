﻿#Область ПрограммныйИнтерфейс

#Область РаботаСПодбором

Процедура ОткрытьПодбор(ФормаВладелец) Экспорт
	
	ПараметрыПодбора = Новый Структура;
	Отказ = Ложь;
	
	ЗаполнитьЗначенияПараметровПодбора(ФормаВладелец, ПараметрыПодбора);
	
	Если НЕ Отказ Тогда
		ОписаниеОповещенияПриЗакрытииПодбора = Новый ОписаниеОповещения("ПриЗакрытииПодбораДокументов", ЭтотОбъект);
		ОткрытьФорму("Обработка.ПодборЗаказовНаПрозводство.Форма.Форма", 
			ПараметрыПодбора, ФормаВладелец, Истина, , , ОписаниеОповещенияПриЗакрытииПодбора, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;	
КонецПроцедуры

// Процедура обработки результатов закрытия подбора
//
Процедура ПриЗакрытииПодбораДокументов(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(РезультатЗакрытия) = Тип("Структура") Тогда
		Если НЕ ПустаяСтрока(РезультатЗакрытия.АдресКорзиныВХранилище) Тогда
			Оповестить("ПодборЗаказовПроизведен", РезультатЗакрытия.АдресКорзиныВХранилище, РезультатЗакрытия.УникальныйИдентификаторФормыВладельца);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ПриЗакрытииПодбора()

// Получение данных из форм-владельцев
Процедура ЗаполнитьЗначенияПараметровПодбора(ФормаВладелец, ПараметрыПодбора)
	
	ПараметрыПодбора.Вставить("Регистратор", ФормаВладелец.ЭтотОбъект.Объект.Ссылка);
	ПараметрыПодбора.Вставить("Проведен", ФормаВладелец.ЭтотОбъект.Объект.Проведен);
	ПараметрыПодбора.Вставить("Организация", ФормаВладелец.ЭтотОбъект.Объект.Организация);
	ПараметрыПодбора.Вставить("Период", ФормаВладелец.ЭтотОбъект.Объект.Дата);
	ПараметрыПодбора.Вставить("ТабличнаяЧастьГП", ФормаВладелец.ЭтотОбъект.Объект.ГотоваяПродукция);
	ПараметрыПодбора.Вставить("УникальныйИдентификаторФормыВладельца", ФормаВладелец.УникальныйИдентификатор);	
		
КонецПроцедуры
// Конец Получение данных из форм-владельцев

#КонецОбласти



#КонецОбласти
