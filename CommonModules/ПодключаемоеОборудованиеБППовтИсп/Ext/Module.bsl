﻿
#Область ВспомогательныеПроцедурыИФункции

// Функция возвращает признак использования торгового оборудования.
//
Функция ИспользоватьПодключаемоеОборудование() Экспорт
	
	 Возврат ПолучитьФункциональнуюОпцию("ИспользоватьПодключаемоеОборудование")
		   И ТипЗнч(Пользователи.АвторизованныйПользователь()) = Тип("СправочникСсылка.Пользователи");
	 
КонецФункции // ИспользоватьПодключаемоеОборудование()

#КонецОбласти
